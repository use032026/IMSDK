import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/admin/admin_http_client.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/media/image_file_service.dart';
import 'package:im_sdk/core/media/image_resource.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/space/account_scope.dart';

enum NetworkImageCacheScope { accountSpace, spaceDirectory }

String resolveNetworkImageUrl(String raw) =>
    ImageResource(raw, HttpClient.baseUrl,
            adminBaseUrl: AdminHttpClient.adminBaseUrl)
        .url;

/// One bounded byte owner for all image entry points. Disk names and keys stay
/// at v3 so existing downloads remain readable after this change.
class ImageByteCache {
  final _bytes = <String, Uint8List>{};
  int _size = 0;

  Uint8List? get(String key) => _bytes[key];

  void put(String key, Uint8List bytes) {
    if (bytes.isEmpty || bytes.lengthInBytes > 1024 * 1024) return;
    final previous = _bytes.remove(key);
    _size -= previous?.lengthInBytes ?? 0;
    _bytes[key] = bytes;
    _size += bytes.lengthInBytes;
    while (_bytes.length > 180 || _size > 16 * 1024 * 1024) {
      _size -= _bytes.remove(_bytes.keys.first)!.lengthInBytes;
    }
  }

  void clear() {
    _bytes.clear();
    _size = 0;
  }
}

class AuthCacheManager extends CacheManager {
  AuthCacheManager(
      {required this.namespace,
      required ImageFileService service,
      required this.bytes,
      Config? config})
      : fileService = service,
        super(config ??
            Config('auth_img_cache_v3_$namespace',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 500,
                fileService: service));

  final String namespace;
  final ImageByteCache bytes;
  final ImageFileService fileService;
  final _memoryLoads = <String>{};
  Iterable<AuthCacheManager> Function()? _directorySources;
  final _directorySeeds = <String, Future<FileInfo?>>{};

  static String scopedMemoryKey(
          {required String namespace, required String url}) =>
      '$namespace:$url';
  String memoryKey(String url) =>
      scopedMemoryKey(namespace: namespace, url: url);
  Uint8List? memoryBytes(String url) {
    final own = bytes.get(memoryKey(url));
    if (own != null) return own;
    for (final source in _directorySources?.call() ?? <AuthCacheManager>[]) {
      final inherited = source.memoryBytes(url);
      if (inherited != null) {
        remember(url, inherited);
        unawaited(_preserveDirectoryFile(url));
        return inherited;
      }
    }
    return null;
  }

  Future<void> _preserveDirectoryFile(String url) async {
    try {
      await getFileFromCache(memoryKey(url));
    } catch (_) {
      // Keep the loaded bytes visible if best-effort disk adoption fails.
    }
  }

  void remember(String url, Uint8List data) => bytes.put(memoryKey(url), data);

  @override
  Future<FileInfo?> getFileFromCache(String key,
      {bool ignoreMemCache = false}) async {
    final own =
        await super.getFileFromCache(key, ignoreMemCache: ignoreMemCache);
    if (own != null ||
        _directorySources == null ||
        !key.startsWith('$namespace:')) {
      return own;
    }
    final pending = _directorySeeds[key];
    if (pending != null) return pending;
    final seed = _seedDirectoryFile(key.substring(namespace.length + 1), key);
    _directorySeeds[key] = seed;
    try {
      return await seed;
    } finally {
      _directorySeeds.remove(key);
    }
  }

  Future<FileInfo?> _seedDirectoryFile(String url, String key) async {
    for (final source in _directorySources!.call()) {
      final cached = await source.getFileFromCache(source.memoryKey(url));
      if (cached == null) continue;
      final data = await cached.file.readAsBytes();
      await putFile(url, data,
          key: key, maxAge: cached.validTill.difference(DateTime.now()));
      remember(url, data);
      return super.getFileFromCache(key);
    }
    return null;
  }

  Stream<Uint8List> imageBytes(String url) async* {
    final memory = memoryBytes(url);
    if (memory != null) yield memory;
    await for (final event in getFileStream(url, key: memoryKey(url))) {
      if (event is! FileInfo) continue;
      final data = await event.file.readAsBytes();
      remember(url, data);
      yield data;
    }
  }

  Future<void> cacheToMemory(String url) async {
    final key = memoryKey(url);
    if (bytes.get(key) != null || !_memoryLoads.add(key)) return;
    try {
      final cached = await getFileFromCache(key);
      if (cached != null) remember(url, await cached.file.readAsBytes());
    } catch (_) {
      // A best-effort byte acceleration must not replace a displayed image.
    } finally {
      _memoryLoads.remove(key);
    }
  }
}

class ImageCacheRegistry {
  ImageCacheRegistry(
      {AuthCacheManager Function(String, ImageByteCache)? factory})
      : _factory = factory;
  final AuthCacheManager Function(String, ImageByteCache)? _factory;
  final _managers = <String, AuthCacheManager>{};
  final _bytes = ImageByteCache();
  final _spaceNamespaces = <String, Set<String>>{};

  AuthCacheManager forAccountSpace(AccountScope scope) {
    _spaceNamespaces
        .putIfAbsent(scope.platformAccountHash, () => <String>{})
        .add(scope.storageKeyHash);
    return forNamespace(scope.storageKeyHash);
  }

  AuthCacheManager forSpaceDirectory(AccountScope scope) {
    forAccountSpace(scope);
    final manager =
        forNamespace('space_directory_v1_${scope.platformAccountHash}');
    manager._directorySources = () =>
        _spaceNamespaces[scope.platformAccountHash]!
            .map((namespace) => _managers[namespace]!);
    return manager;
  }

  AuthCacheManager forNamespace(String namespace) => _managers.putIfAbsent(
      namespace,
      () =>
          _factory?.call(namespace, _bytes) ??
          AuthCacheManager(
              namespace: namespace,
              service: ImageFileService(),
              bytes: _bytes));

  Future<void> dispose() async {
    await Future.wait(_managers.values.map((manager) => manager.dispose()));
    _managers.clear();
    _spaceNamespaces.clear();
    _bytes.clear();
  }
}

// Root-owned disk handles must not close while a retiring widget/provider still
// reads them, or close a newly reopened sqflite handle for the same namespace.
final imageCacheRegistryProvider = Provider<ImageCacheRegistry>((ref) {
  final registry = ImageCacheRegistry();
  ref.onDispose(() => unawaited(registry.dispose()));
  return registry;
});

final _publicImageDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30)));
  ref.onDispose(() => dio.close(force: true));
  return dio;
});

final accountAuthCacheManagerProvider = Provider<AuthCacheManager>((ref) {
  final context = ref.watch(accountStorageContextProvider);
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (context == null || space == null || !context.scope.ownsSpace(space)) {
    throw StateError('authenticated image cache requires an active account');
  }
  final manager =
      ref.read(imageCacheRegistryProvider).forAccountSpace(context.scope);
  return _bindAccountImageTransport(ref, manager, context.scope);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  dioProvider,
  adminDioProvider,
]);

AuthCacheManager _bindAccountImageTransport(
    Ref ref, AuthCacheManager manager, AccountScope scope) {
  var active = true;
  final detach = manager.fileService.attach(ImageDownloadTransport(
    publicDio: ref.read(_publicImageDioProvider),
    accountDio: ref.watch(dioProvider),
    adminDio: () => ref.read(adminDioProvider),
    adminBaseUrl: () => AdminHttpClient.adminBaseUrl,
    apiBaseUrl: () => HttpClient.baseUrl,
    namespace: manager.namespace,
    diagnosticScope: DiagnosticScope.account(scope),
    isCurrent: () =>
        active && ref.read(accountRuntimeCurrentSpaceProvider) != null,
  ));
  ref.onDispose(() {
    active = false;
    detach();
  });
  return manager;
}

// Login/space selection can show public logos before a tenant runtime exists.
// It has its own anonymous namespace and can never request private media.
final networkImageCacheManagerProvider = Provider<AuthCacheManager>((ref) {
  if (ref.watch(accountStorageContextProvider) != null) {
    return ref.watch(accountAuthCacheManagerProvider);
  }
  final manager = ref.read(imageCacheRegistryProvider).forNamespace('public');
  final detach = manager.fileService.attach(ImageDownloadTransport(
    publicDio: ref.read(_publicImageDioProvider),
    apiBaseUrl: () => HttpClient.baseUrl,
    namespace: 'public',
    diagnosticScope: DiagnosticScope.public,
    adminBaseUrl: () => AdminHttpClient.adminBaseUrl,
    isCurrent: () => true,
  ));
  ref.onDispose(detach);
  return manager;
}, dependencies: [
  accountStorageContextProvider,
  accountAuthCacheManagerProvider
]);

/// Catalog logos belong to the platform account, not the active tenant.
final spaceDirectoryImageCacheManagerProvider =
    Provider<AuthCacheManager>((ref) {
  final context = ref.watch(accountStorageContextProvider);
  if (context == null) return ref.watch(networkImageCacheManagerProvider);
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (!context.scope.ownsSpace(space)) {
    throw StateError('space directory images require an active account');
  }
  final manager =
      ref.read(imageCacheRegistryProvider).forSpaceDirectory(context.scope);
  return _bindAccountImageTransport(ref, manager, context.scope);
}, dependencies: [
  accountStorageContextProvider,
  accountRuntimeCurrentSpaceProvider,
  networkImageCacheManagerProvider,
  dioProvider,
  adminDioProvider
]);

Future<void> prefetchAvatarUrls(
  List<String?> urls, {
  required AuthCacheManager cacheManager,
  bool downloadMissing = false,
  int maxCount = 72,
}) async {
  final seen = <String>{};
  for (final raw in urls) {
    if (raw == null || raw.isEmpty) continue;
    final url = resolveNetworkImageUrl(raw);
    if (!seen.add(url)) continue;
    if (seen.length > maxCount) break;
    if (cacheManager.memoryBytes(url) != null) continue;
    try {
      final key = cacheManager.memoryKey(url);
      final cached = await cacheManager.getFileFromCache(key);
      final file = cached ??
          (downloadMissing
              ? await cacheManager.downloadFile(url, key: key)
              : null);
      if (file != null) {
        cacheManager.remember(url, await file.file.readAsBytes());
      }
    } catch (_) {
      // Prefetch is optional; the normal loader owns errors and recovery.
    }
  }
}

import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kFontSizeKey = 'app_font_size_scale';

final fontSizeScaleProvider = NotifierProvider<FontSizeScaleNotifier, double>(
  FontSizeScaleNotifier.new,
);

class FontSizeScaleNotifier extends Notifier<double> {
  @override
  double build() {
    try {
      final box = HiveStorage.settingsBox;
      return double.tryParse(box.get(_kFontSizeKey) ?? '') ?? 1.0;
    } catch (_) {
      return 1.0;
    }
  }

  Future<void> setScale(double scale) async {
    final normalized = scale.clamp(0.88, 1.18).toDouble();
    state = normalized;
    try {
      final box = HiveStorage.settingsBox;
      await box.put(_kFontSizeKey, normalized.toString());
    } catch (_) {}
  }
}

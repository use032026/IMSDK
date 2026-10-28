#!/usr/bin/env python3
"""Generate a pure native host project against the delivered XCFramework set."""
from hashlib import sha256
from pathlib import Path
import json
import os
import plistlib

root = Path(__file__).resolve().parents[1]
example = root / 'native/ios/example'
project = example / 'IMSDKHost.xcodeproj'
integration = root / 'dist/ios/INTEGRATION.json'
framework_mode = os.environ.get('IMSDK_IOS_FRAMEWORK_MODE', 'Release')
if framework_mode not in {'Debug', 'Profile', 'Release'}:
    raise SystemExit('IMSDK_IOS_FRAMEWORK_MODE must be Debug, Profile or Release.')
if not integration.is_file():
    raise SystemExit('Build the iOS SDK framework set and integration manifest first.')
frameworks = json.loads(integration.read_text())
for entry in frameworks:
    if not (root / 'dist/ios' / framework_mode / entry['framework']).is_dir():
        raise SystemExit('Missing binary: ' + entry['framework'])

objects = {}

def identifier(name):
    return sha256(name.encode()).hexdigest()[:24].upper()

def add(name, value):
    key = identifier(name)
    objects[key] = value
    return key

def ref(name):
    return identifier(name)

def encode(value, level=0):
    if isinstance(value, dict):
        body = '\n'.join('  ' * (level + 1) + json.dumps(str(k)) + ' = ' + encode(v, level + 1) + ';' for k, v in value.items())
        return '{\n' + body + '\n' + '  ' * level + '}'
    if isinstance(value, list):
        return '(' + ', '.join(encode(v, level) for v in value) + ')'
    return json.dumps(str(value))

source_builds = []
test_builds = []
source_refs = []
test_refs = []
for relative in ['IMSDKHost/AppDelegate.swift', 'IMSDKHost/HostViewController.swift']:
    file = add('file-' + relative, {'isa': 'PBXFileReference', 'lastKnownFileType': 'sourcecode.swift', 'path': relative, 'sourceTree': 'SOURCE_ROOT'})
    source_refs.append(file)
    source_builds.append(add('build-' + relative, {'isa': 'PBXBuildFile', 'fileRef': file}))
for relative in ['IMSDKHostUITests/IMSDKHostUITests.swift']:
    file = add('file-' + relative, {'isa': 'PBXFileReference', 'lastKnownFileType': 'sourcecode.swift', 'path': relative, 'sourceTree': 'SOURCE_ROOT'})
    test_refs.append(file)
    test_builds.append(add('build-' + relative, {'isa': 'PBXBuildFile', 'fileRef': file}))
info = add('info', {'isa': 'PBXFileReference', 'lastKnownFileType': 'text.plist.xml', 'path': 'IMSDKHost/Info.plist', 'sourceTree': 'SOURCE_ROOT'})
configuration = add('configuration', {'isa': 'PBXFileReference', 'lastKnownFileType': 'text.plist.xml', 'path': 'IMSDKHost/IMSDKConfiguration.plist', 'sourceTree': 'SOURCE_ROOT'})
configuration_resource = add('configuration-resource', {'isa': 'PBXBuildFile', 'fileRef': configuration})
entitlements = add('entitlements', {'isa': 'PBXFileReference', 'lastKnownFileType': 'text.plist.entitlements', 'path': 'IMSDKHost/IMSDKHost.entitlements', 'sourceTree': 'SOURCE_ROOT'})
binary_refs = []
binary_builds = []
embed_builds = []
for entry in frameworks:
    name = entry['framework']
    file = add('xcframework-' + name, {'isa': 'PBXFileReference', 'lastKnownFileType': 'wrapper.xcframework',
        'path': '../../../dist/ios/' + framework_mode + '/' + name, 'sourceTree': 'SOURCE_ROOT'})
    binary_refs.append(file)
    binary_builds.append(add('link-' + name, {'isa': 'PBXBuildFile', 'fileRef': file}))
    if entry['kind'] == 'dynamic':
        embed_builds.append(add('embed-' + name, {'isa': 'PBXBuildFile', 'fileRef': file,
            'settings': {'ATTRIBUTES': ['CodeSignOnCopy', 'RemoveHeadersOnCopy']}}))

app_product = add('app-product', {'isa': 'PBXFileReference', 'explicitFileType': 'wrapper.application', 'path': 'IMSDKHost.app', 'sourceTree': 'BUILT_PRODUCTS_DIR'})
test_product = add('test-product', {'isa': 'PBXFileReference', 'explicitFileType': 'wrapper.cfbundle', 'path': 'IMSDKHostUITests.xctest', 'sourceTree': 'BUILT_PRODUCTS_DIR'})
products = add('products', {'isa': 'PBXGroup', 'children': [app_product, test_product], 'name': 'Products', 'sourceTree': '<group>'})
binary_group = add('frameworks', {'isa': 'PBXGroup', 'children': binary_refs, 'name': 'Delivered SDK Binaries', 'sourceTree': '<group>'})
main_group = add('main-group', {'isa': 'PBXGroup', 'children': source_refs + test_refs + [info, configuration, entitlements, binary_group, products], 'sourceTree': '<group>'})
app_sources = add('app-sources', {'isa': 'PBXSourcesBuildPhase', 'buildActionMask': '2147483647', 'files': source_builds, 'runOnlyForDeploymentPostprocessing': '0'})
app_frameworks = add('app-frameworks', {'isa': 'PBXFrameworksBuildPhase', 'buildActionMask': '2147483647', 'files': binary_builds, 'runOnlyForDeploymentPostprocessing': '0'})
app_resources = add('app-resources', {'isa': 'PBXResourcesBuildPhase', 'buildActionMask': '2147483647', 'files': [configuration_resource], 'runOnlyForDeploymentPostprocessing': '0'})
app_embed = add('app-embed', {'isa': 'PBXCopyFilesBuildPhase', 'buildActionMask': '2147483647', 'dstPath': '', 'dstSubfolderSpec': '10',
    'files': embed_builds, 'name': 'Embed Dynamic Frameworks Only', 'runOnlyForDeploymentPostprocessing': '0'})
test_sources = add('test-sources', {'isa': 'PBXSourcesBuildPhase', 'buildActionMask': '2147483647', 'files': test_builds, 'runOnlyForDeploymentPostprocessing': '0'})
test_frameworks = add('test-frameworks', {'isa': 'PBXFrameworksBuildPhase', 'buildActionMask': '2147483647', 'files': [], 'runOnlyForDeploymentPostprocessing': '0'})
test_resources = add('test-resources', {'isa': 'PBXResourcesBuildPhase', 'buildActionMask': '2147483647', 'files': [], 'runOnlyForDeploymentPostprocessing': '0'})

for kind in ['project', 'app', 'test']:
    configs = []
    for mode in ['Debug', 'Release']:
        settings = {'CLANG_ENABLE_MODULES': 'YES', 'SWIFT_VERSION': '5.0', 'IPHONEOS_DEPLOYMENT_TARGET': '15.0',
            'SDKROOT': 'iphoneos', 'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator', 'TARGETED_DEVICE_FAMILY': '1,2',
            'CODE_SIGN_STYLE': 'Automatic', 'CODE_SIGN_IDENTITY[sdk=iphonesimulator*]': '-', 'ENABLE_BITCODE': 'NO',
            'SWIFT_OPTIMIZATION_LEVEL': '-Onone' if mode == 'Debug' else '-O'}
        if mode == 'Debug':
            settings.update({'SWIFT_ACTIVE_COMPILATION_CONDITIONS': '$(inherited) DEBUG', 'ENABLE_TESTABILITY': 'YES'})
        if kind == 'app':
            settings.update({'PRODUCT_BUNDLE_IDENTIFIER': 'com.example.imsdkhost.ios', 'PRODUCT_NAME': '$(TARGET_NAME)',
                'INFOPLIST_FILE': 'IMSDKHost/Info.plist', 'CODE_SIGN_ENTITLEMENTS': 'IMSDKHost/IMSDKHost.entitlements', 'LD_RUNPATH_SEARCH_PATHS': ['$(inherited)', '@executable_path/Frameworks'],
                'OTHER_LDFLAGS': ['$(inherited)', '-ObjC']})
        elif kind == 'test':
            settings.update({'PRODUCT_BUNDLE_IDENTIFIER': 'com.example.imsdkhost.ios.uitests', 'PRODUCT_NAME': '$(TARGET_NAME)',
                'GENERATE_INFOPLIST_FILE': 'YES', 'TEST_TARGET_NAME': 'IMSDKHost',
                'LD_RUNPATH_SEARCH_PATHS': ['$(inherited)', '@executable_path/Frameworks', '@loader_path/Frameworks']})
        configs.append(add(kind + '-' + mode, {'isa': 'XCBuildConfiguration', 'buildSettings': settings, 'name': mode}))
    add(kind + '-configs', {'isa': 'XCConfigurationList', 'buildConfigurations': configs, 'defaultConfigurationIsVisible': '0', 'defaultConfigurationName': 'Release'})

proxy = add('test-proxy', {'isa': 'PBXContainerItemProxy', 'containerPortal': ref('project'), 'proxyType': '1', 'remoteGlobalIDString': ref('app-target'), 'remoteInfo': 'IMSDKHost'})
dependency = add('test-dependency', {'isa': 'PBXTargetDependency', 'target': ref('app-target'), 'targetProxy': proxy})
add('app-target', {'isa': 'PBXNativeTarget', 'buildConfigurationList': ref('app-configs'), 'buildPhases': [app_sources, app_frameworks, app_resources, app_embed],
    'buildRules': [], 'dependencies': [], 'name': 'IMSDKHost', 'productName': 'IMSDKHost', 'productReference': app_product, 'productType': 'com.apple.product-type.application'})
add('test-target', {'isa': 'PBXNativeTarget', 'buildConfigurationList': ref('test-configs'), 'buildPhases': [test_sources, test_frameworks, test_resources],
    'buildRules': [], 'dependencies': [dependency], 'name': 'IMSDKHostUITests', 'productName': 'IMSDKHostUITests', 'productReference': test_product, 'productType': 'com.apple.product-type.bundle.ui-testing'})
add('project', {'isa': 'PBXProject', 'attributes': {'LastUpgradeCheck': '2600', 'LastSwiftUpdateCheck': '2600',
    'TargetAttributes': {ref('app-target'): {'CreatedOnToolsVersion': '26.0'}, ref('test-target'): {'CreatedOnToolsVersion': '26.0', 'TestTargetID': ref('app-target')}}},
    'buildConfigurationList': ref('project-configs'), 'compatibilityVersion': 'Xcode 14.0', 'developmentRegion': 'zh_CN', 'hasScannedForEncodings': '0',
    'knownRegions': ['zh_CN', 'en', 'Base'], 'mainGroup': main_group, 'productRefGroup': products, 'projectDirPath': '', 'projectRoot': '',
    'targets': [ref('app-target'), ref('test-target')]})
document = {'archiveVersion': '1', 'classes': {}, 'objectVersion': '56', 'objects': objects, 'rootObject': ref('project')}
project.mkdir(parents=True, exist_ok=True)
(project / 'project.pbxproj').write_text('// !$*UTF8*$!\n' + encode(document) + '\n')
scheme = project / 'xcshareddata/xcschemes/IMSDKHost.xcscheme'
scheme.parent.mkdir(parents=True, exist_ok=True)

def buildable(name, product, target):
    return f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ref(target)}" BuildableName="{product}" BlueprintName="{name}" ReferencedContainer="container:IMSDKHost.xcodeproj"/>'

app = buildable('IMSDKHost', 'IMSDKHost.app', 'app-target')
tests = buildable('IMSDKHostUITests', 'IMSDKHostUITests.xctest', 'test-target')
scheme.write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="2600" version="1.3">
  <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES"><BuildActionEntries>
    <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{app}</BuildActionEntry>
    <BuildActionEntry buildForTesting="YES" buildForRunning="NO" buildForProfiling="NO" buildForArchiving="NO" buildForAnalyzing="YES">{tests}</BuildActionEntry>
  </BuildActionEntries></BuildAction>
  <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" customLLDBInitFile="$(SRCROOT)/../../../dist/ios/flutter_lldbinit" shouldUseLaunchSchemeArgsEnv="YES">
    <MacroExpansion>{app}</MacroExpansion>
    <Testables><TestableReference skipped="NO">{tests}</TestableReference></Testables>
  </TestAction>
  <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" customLLDBInitFile="$(SRCROOT)/../../../dist/ios/flutter_lldbinit" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></LaunchAction>
  <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></ProfileAction>
  <AnalyzeAction buildConfiguration="Debug"/>
  <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
''')
print(f'Generated pure native project: {project}; mode={framework_mode}; linked {len(frameworks)} binary frameworks, embedded {len(embed_builds)} dynamic frameworks')

#!/usr/bin/env python3
"""Generate native-only consumer projects beside a handoff's binary/Maven folders.

The checked-in handoff/sample-host sources are the templates. This generator
only creates the iOS project and copies the existing Android Gradle wrapper; it
does not build the SDK or read private integration inputs.
"""
from __future__ import annotations

import argparse
from hashlib import sha256
import json
from pathlib import Path
import shutil


ROOT = Path(__file__).resolve().parents[1]


def generate_ios(destination: Path) -> None:
    template = ROOT / "native/ios/handoff/sample-host"
    if destination.resolve() != template.resolve():
        destination.mkdir(parents=True, exist_ok=True)
        shutil.copy2(template / "README.md", destination / "README.md")
        for name in ("AppDelegate.swift", "HostViewController.swift", "Info.plist", "IMSDKConfiguration.plist"):
            source = template / "IMSDKHost" / name
            target = destination / "IMSDKHost" / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, target)
    frameworks = json.loads((ROOT / "dist/ios/INTEGRATION.json").read_text())
    names = [entry["framework"] for entry in frameworks]
    if len(names) != len(set(names)) or any(Path(name).name != name or not name.endswith(".xcframework") for name in names):
        raise SystemExit("Invalid iOS framework manifest")
    if any(entry["kind"] not in {"static", "dynamic"} for entry in frameworks):
        raise SystemExit("Unknown framework kind in iOS integration manifest")
    objects = {}

    def ref(name):
        return sha256(name.encode()).hexdigest()[:24].upper()

    def add(name, value):
        key = ref(name)
        objects[key] = value
        return key

    def encode(value, level=0):
        if isinstance(value, dict):
            body = "\n".join("  " * (level + 1) + json.dumps(str(k)) + " = " + encode(v, level + 1) + ";" for k, v in value.items())
            return "{\n" + body + "\n" + "  " * level + "}"
        if isinstance(value, list):
            return "(" + ", ".join(encode(v, level) for v in value) + ")"
        return json.dumps(str(value))

    source_refs, source_builds = [], []
    for name in ("AppDelegate.swift", "HostViewController.swift"):
        item = add("source-" + name, {"isa": "PBXFileReference", "lastKnownFileType": "sourcecode.swift", "path": "IMSDKHost/" + name, "sourceTree": "SOURCE_ROOT"})
        source_refs.append(item)
        source_builds.append(add("compile-" + name, {"isa": "PBXBuildFile", "fileRef": item}))
    info = add("info", {"isa": "PBXFileReference", "lastKnownFileType": "text.plist.xml", "path": "IMSDKHost/Info.plist", "sourceTree": "SOURCE_ROOT"})
    config = add("config", {"isa": "PBXFileReference", "lastKnownFileType": "text.plist.xml", "path": "IMSDKHost/IMSDKConfiguration.plist", "sourceTree": "SOURCE_ROOT"})
    config_resource = add("config-resource", {"isa": "PBXBuildFile", "fileRef": config})
    binary_refs, binary_builds, embed_builds = [], [], []
    for entry in frameworks:
        name = entry["framework"]
        item = add("binary-" + name, {"isa": "PBXFileReference", "lastKnownFileType": "wrapper.xcframework", "path": "../binary/$(IMSDK_BINARY_MODE)/" + name, "sourceTree": "SOURCE_ROOT"})
        binary_refs.append(item)
        binary_builds.append(add("link-" + name, {"isa": "PBXBuildFile", "fileRef": item}))
        if entry["kind"] == "dynamic":
            embed_builds.append(add("embed-" + name, {"isa": "PBXBuildFile", "fileRef": item, "settings": {"ATTRIBUTES": ["CodeSignOnCopy", "RemoveHeadersOnCopy"]}}))
    product = add("product", {"isa": "PBXFileReference", "explicitFileType": "wrapper.application", "path": "IMSDKHost.app", "sourceTree": "BUILT_PRODUCTS_DIR"})
    products = add("products", {"isa": "PBXGroup", "children": [product], "name": "Products", "sourceTree": "<group>"})
    binaries = add("binaries", {"isa": "PBXGroup", "children": binary_refs, "name": "Delivered SDK Binaries", "sourceTree": "<group>"})
    group = add("group", {"isa": "PBXGroup", "children": source_refs + [info, config, binaries, products], "sourceTree": "<group>"})
    sources = add("sources", {"isa": "PBXSourcesBuildPhase", "buildActionMask": "2147483647", "files": source_builds, "runOnlyForDeploymentPostprocessing": "0"})
    links = add("links", {"isa": "PBXFrameworksBuildPhase", "buildActionMask": "2147483647", "files": binary_builds, "runOnlyForDeploymentPostprocessing": "0"})
    resources = add("resources", {"isa": "PBXResourcesBuildPhase", "buildActionMask": "2147483647", "files": [config_resource], "runOnlyForDeploymentPostprocessing": "0"})
    embed = add("embed", {"isa": "PBXCopyFilesBuildPhase", "buildActionMask": "2147483647", "dstPath": "", "dstSubfolderSpec": "10", "files": embed_builds, "name": "Embed Dynamic Frameworks Only", "runOnlyForDeploymentPostprocessing": "0"})
    for kind in ("project", "app"):
        configurations = []
        for mode in ("Debug", "Release"):
            settings = {"CLANG_ENABLE_MODULES": "YES", "SWIFT_VERSION": "5.0", "IPHONEOS_DEPLOYMENT_TARGET": "15.0", "SDKROOT": "iphoneos", "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator", "TARGETED_DEVICE_FAMILY": "1,2", "CODE_SIGN_STYLE": "Automatic", "CODE_SIGN_IDENTITY[sdk=iphonesimulator*]": "-", "ENABLE_BITCODE": "NO", "SWIFT_OPTIMIZATION_LEVEL": "-Onone" if mode == "Debug" else "-O", "IMSDK_BINARY_MODE": mode}
            if mode == "Debug":
                settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = "$(inherited) DEBUG"
            if kind == "app":
                settings.update({"PRODUCT_BUNDLE_IDENTIFIER": "com.example.imsdkhost.ios", "PRODUCT_NAME": "$(TARGET_NAME)", "INFOPLIST_FILE": "IMSDKHost/Info.plist", "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"], "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"]})
            configurations.append(add(kind + "-" + mode, {"isa": "XCBuildConfiguration", "buildSettings": settings, "name": mode}))
        add(kind + "-configs", {"isa": "XCConfigurationList", "buildConfigurations": configurations, "defaultConfigurationIsVisible": "0", "defaultConfigurationName": "Release"})
    add("target", {"isa": "PBXNativeTarget", "buildConfigurationList": ref("app-configs"), "buildPhases": [sources, links, resources, embed], "buildRules": [], "dependencies": [], "name": "IMSDKHost", "productName": "IMSDKHost", "productReference": product, "productType": "com.apple.product-type.application"})
    add("project", {"isa": "PBXProject", "attributes": {"LastUpgradeCheck": "2600", "LastSwiftUpdateCheck": "2600", "TargetAttributes": {ref("target"): {"CreatedOnToolsVersion": "26.0"}}}, "buildConfigurationList": ref("project-configs"), "compatibilityVersion": "Xcode 14.0", "developmentRegion": "zh_CN", "hasScannedForEncodings": "0", "knownRegions": ["zh_CN", "en", "Base"], "mainGroup": group, "productRefGroup": products, "projectDirPath": "", "projectRoot": "", "targets": [ref("target")]})
    project = destination / "IMSDKHost.xcodeproj"
    project.mkdir(parents=True, exist_ok=True)
    (project / "project.pbxproj").write_text("// !$*UTF8*$!\n" + encode({"archiveVersion": "1", "classes": {}, "objectVersion": "56", "objects": objects, "rootObject": ref("project")}) + "\n")
    app = f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ref("target")}" BuildableName="IMSDKHost.app" BlueprintName="IMSDKHost" ReferencedContainer="container:IMSDKHost.xcodeproj"/>'
    scheme = project / "xcshareddata/xcschemes/IMSDKHost.xcscheme"
    scheme.parent.mkdir(parents=True, exist_ok=True)
    scheme.write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="2600" version="1.3">
  <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES"><BuildActionEntries><BuildActionEntry buildForTesting="NO" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{app}</BuildActionEntry></BuildActionEntries></BuildAction>
  <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" customLLDBInitFile="$(SRCROOT)/../binary/flutter_lldbinit" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></LaunchAction>
  <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></ProfileAction>
  <AnalyzeAction buildConfiguration="Debug"/>
  <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
''')
    print(f"Generated iOS host: {len(frameworks)} linked frameworks, {len(embed_builds)} embedded dynamic frameworks")


def generate_android(destination: Path) -> None:
    template = ROOT / "native/android/handoff/sample-host"
    if destination.resolve() != template.resolve():
        files = ["README.md", "settings.gradle.kts", "gradle.properties", "app/build.gradle.kts", "app/src/main/AndroidManifest.xml", "app/src/main/java/com/example/imsdkhost/MainActivity.java", "app/src/main/assets/im_sdk_configuration.json"]
        for name in files:
            target = destination / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(template / name, target)
    for name in ("gradlew", "gradlew.bat", "gradle/wrapper/gradle-wrapper.jar", "gradle/wrapper/gradle-wrapper.properties"):
        target = destination / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ROOT / "native/android" / name, target)
    (destination / "gradlew").chmod(0o755)
    print("Generated Android host with its own Gradle wrapper; local Maven repository: ../maven")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=("all", "ios", "android"), default="all")
    parser.add_argument("--ios-output", type=Path, default=ROOT / "native/ios/handoff/sample-host")
    parser.add_argument("--android-output", type=Path, default=ROOT / "native/android/handoff/sample-host")
    args = parser.parse_args()
    if args.platform in {"all", "ios"}:
        generate_ios(args.ios_output)
    if args.platform in {"all", "android"}:
        generate_android(args.android_output)


if __name__ == "__main__":
    main()

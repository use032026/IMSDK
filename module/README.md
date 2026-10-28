# Native add-to-app build module

Generated with Flutter 3.41.9 `--template=module --no-pub`. The only Dart entrypoint imports the independent `im_sdk` package and calls `runImSdkNativeHost()`.

Use the root dependency/build scripts. `.android` and `.ios` are regenerated tooling wrappers, excluded from source delivery; scripts configure desugaring and iOS 15 on those generated files. Native plugin implementation lives in `../packages/im_sdk`, not in the generated wrapper. No original App signing, vendor push configuration or native shell is copied here.

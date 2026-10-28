plugins { id("com.android.application") }

android {
    namespace = "com.example.imsdkhost"
    compileSdk = 36
    defaultConfig {
        applicationId = "com.example.imsdkhost"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    implementation("com.imsdk:im-sdk-native:0.1.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

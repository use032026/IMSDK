plugins { id("com.android.application") }

android {
    namespace = "com.example.imsdkhost"
    compileSdk = 36
    buildFeatures { buildConfig = true }
    defaultConfig {
        // An example identity only; production hosts use their own application ID and signing.
        applicationId = "com.example.imsdkhost"
        minSdk = 24
        targetSdk = 36
        versionCode = 2
        versionName = "0.1.1"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    implementation("com.imsdk:im-sdk-native:0.1.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

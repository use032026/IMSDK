import org.gradle.api.publish.maven.MavenPublication

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    `maven-publish`
}

group = "com.imsdk"
version = "0.1.3"

android {
    namespace = "com.imsdk.nativebridge"
    compileSdk = 36
    defaultConfig {
        minSdk = 24
        consumerProguardFiles("consumer-rules.pro")
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
    publishing { singleVariant("release") { withSourcesJar() } }
}

dependencies {
    // Override when the generated module uses a different Maven group/version.
    api(providers.gradleProperty("imSdkFlutterArtifact")
        .orElse("com.startlink.im_sdk_module:flutter_release:0.1.3").get())
}

afterEvaluate {
    publishing {
        repositories {
            maven { url = uri("../../dist/android/maven") }
        }
        publications {
            create<MavenPublication>("release") {
                from(components["release"])
                artifactId = "im-sdk-native"
            }
        }
    }
}

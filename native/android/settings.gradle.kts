pluginManagement {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        google(); mavenCentral(); gradlePluginPortal()
    }
    plugins {
        id("com.android.library") version "8.11.1"
        id("org.jetbrains.kotlin.android") version "2.2.20"
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
        maven {
            url = uri(providers.gradleProperty("imSdkFlutterRepository")
                .orElse(file("../../dist/android/maven").absolutePath).get())
        }
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

rootProject.name = "im-sdk-native"

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dj_music_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.dj_music_app"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Giảm thiểu log SidecarWindowBackend trên Android cũ
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        debug {
            // Tắt shrink trong debug để tránh lỗi class resolution
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Loại bỏ thư viện sidecar gây lỗi NoClassDefFoundError
    configurations.all {
        resolutionStrategy {
            force("androidx.window:window:1.0.0")
            force("androidx.window:window-java:1.0.0")
        }
    }
}

dependencies {
    // Fix lỗi SidecarWindowBackend / NoClassDefFoundError
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
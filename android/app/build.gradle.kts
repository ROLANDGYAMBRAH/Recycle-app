@Suppress("UnstableApiUsage")
plugins {
    id("com.android.application")

    // ─── FlutterFire (Firebase) Configuration ────────────────────────────────
    id("com.google.gms.google-services")

    // ─── Kotlin & Flutter plugins ────────────────────────────────────────────
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")      // must be last among Android/Kotlin
}

android {
    namespace  = "com.example.eco_trade_final"
    compileSdk = flutter.compileSdkVersion       // resolves from gradle.properties
    ndkVersion = "27.0.12077973"                 // ✅ manual NDK override

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
    applicationId = "com.example.eco_trade_final"
    minSdk = 23                     // ✅ Force minSdk to 23 here
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}


    buildTypes {
        getByName("release") {
            // Uses debug keystore for now; replace before publishing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


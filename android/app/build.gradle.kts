import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}



// 声明 获取签名配置 配置文件路径
val signProperties = rootProject.file("sign/keystore.properties")
val props = Properties().apply {
    load(FileInputStream(signProperties))
}
val file = file(props["storeFile"] as String)

android {
    namespace = "com.suzumiya.example"
    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            // 如果秘钥库文件和配置文件存在就签名，否则不签名
            if (file.exists() && signProperties.exists()) {
                keyAlias = props["keyAlias"] as String
                keyPassword = props["keyPassword"] as String
                storeFile = file
                storePassword = props["storePassword"] as String
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.suzumiya.example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig = signingConfigs.getByName("debug")
            // 混淆
            isMinifyEnabled = true
            // 去除无用res文件
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // 使用签名文件
            signingConfig = signingConfigs.getByName("release")
        }
    }

//    applicationVariants.all { variant ->
//        variant.outputs.all { output ->
//            val outputFile = output.outputFile
//            if (outputFile != null && outputFile.name.endsWith(".apk")) {
//                var outputFileName = ""
//                if (variant.buildType.name == "release") {
//                    outputFileName = "${defaultConfig.applicationId}_v${defaultConfig.versionName}_.apk"
//                } else {
//                    outputFileName = "${defaultConfig.applicationId}_v${defaultConfig.versionName}_.apk"
//                }
//                output.outputFile = outputFileName
//            }
//        }
//    }
}

flutter {
    source = "../.."
}

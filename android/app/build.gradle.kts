plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin correctamente aplicado
}

android {
    namespace = "com.example.garantias"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Ajuste para compatibilidad con NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Mejora compatibilidad con dependencias modernas
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // Agrega desugaring para soporte de Java 8+
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // Usa Java 17 para mayor estabilidad
    }

    defaultConfig {
        applicationId = "com.example.garantias"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Configuración correcta
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.9.0") // Compatibilidad con AndroidX
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-ktx:1.9.0")
    implementation("androidx.appcompat:appcompat:1.6.1") // NECESARIO para temas clásicos
    implementation("com.google.android.material:material:1.9.0") // NECESARIO para Material Components

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

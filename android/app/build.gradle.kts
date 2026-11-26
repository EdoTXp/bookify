import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties

plugins {
    id("com.android.application")
    alias(libs.plugins.google.services)
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile: File = rootProject.file("key.properties")
val keystoreProperties = Properties()

keystorePropertiesFile.inputStream().use {
    keystoreProperties.load(it)
}

android {
    namespace = "com.bookifysoftware.bookify"
    compileSdk = 37

    defaultConfig {
        applicationId = "com.bookifysoftware.bookify"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    signingConfigs {
        create("config") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        debug {
            versionNameSuffix = "-DEBUG"
            signingConfig = signingConfigs.getByName("config")
        }

        release {
            signingConfig = signingConfigs.getByName("config")
        }
    }

    testOptions {
        execution = "ANDROIDX_TEST_ORCHESTRATOR"
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring(libs.android.desugar.jdk.libs)
    implementation(libs.androidx.window)
    implementation(libs.androidx.window.java)
    androidTestUtil(libs.androidx.test.orchestrator)
}

flutter {
    source = "../.."
}
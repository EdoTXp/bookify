# Setup & Build Guide - Bookify

This document provides a comprehensive step-by-step walkthrough to clone, configure, compile, and run the Bookify project locally on your machine.

---

## 📋 Prerequisites

Before starting, ensure you have the following installed and configured on your operating system:

- **Flutter SDK** (`>=3.10.0 <4.0.0`)
- **Dart SDK** (`>=3.10.0 <4.0.0`)
- **Node.js** (required for Firebase CLI tooling)
- **OpenSSH** toolchain

---

## 🛠️ Step-by-Step Setup

### 1. Clone the Project

Begin by cloning the repository using git:

```bash
git clone [https://github.com/EdoTXp/bookify](https://github.com/EdoTXp/bookify)
cd bookify
```

### 2. Firebase Console Setup

Bookify integrates with Firebase for core authorization mechanisms.

1. Navigate to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new Firebase project.
3. Register your respective **Android** and **iOS** application packages inside the project configurations.
4. Go to the **Authentication** tab and enable the following Sign-in Providers:
   - **Google Authentication** (for Android)
   - **Facebook Authentication** (for both Android and iOS)

### 3. OpenSSH Configuration

Ensure OpenSSH is installed and running on your system environment. This toolset is required to process and output security signatures and tokens when binding identity hashes with external developer providers.

### 4. Facebook Developer Portal Integration

To bind Facebook authorization tokens into Firebase:

1. Access the [Facebook Developer Portal](https://developers.facebook.com/).
2. Initialize a new Application instance and activate the **Facebook Login** product for both Android and iOS platforms.
3. Reference the official configuration instructions for detailed native setup steps:
   - [Facebook Login Setup for Android](https://developers.facebook.com/docs/facebook-login/android)
   - [Facebook Login Setup for iOS](https://developers.facebook.com/docs/facebook-login/ios)
4. Copy your generated **App ID** and **App Secret** tokens from the Facebook dashboard, return to the Firebase Console Authentication dashboard, and input them under the Facebook provider settings.

### 5. Generate Keystore Fingerprints for Google Login

For Android application integration, you must supply debug and release SHA fingerprints to Firebase.

#### Generate Local Debug Signatures

Execute the following keytool utility command:

```bash
keytool -list -v -keystore <path-to-your-debug-keystore> -alias <key-alias> -storepass <keystore-password> -keypass <key-password>
```

> 💡 **Note:** Copy the resulting SHA-1 and SHA-256 blocks directly into your Firebase Android Application profile.

#### Generate Release Signatures

For official distribution profiles, reference the standard Android signing documentation pipelines:

- [Android App Signing Official Guide](https://developer.android.com/studio/publish/app-signing)
- [Google Client Authentication Guide](https://developers.google.com/identity/sign-in/android/start-integrating)

### 6. Apple Sign-In Notice

> ⚠️ **Notice:** This project does not actively bundle configured Apple Sign-In provisioning profiles due to the lack of an active Apple Developer Team ID. If you choose to configure this environment on your custom clone, apply the setup steps through the [Apple Sign-In Documentation](https://developer.apple.com/documentation/sign_in_with_apple) and add the identifiers to your Firebase dashboard.

### 7. Install Firebase CLI Tooling

1. Globally install the Firebase Command Line Interface using npm:

   ```bash
   npm install -g firebase-tools
   ```

2. Authenticate your terminal context into your Firebase account:

   ```bash
   firebase login
   ```

3. Activate the global FlutterFire configuration toolset:

   ```bash
   dart pub global activate flutterfire_cli
   ```

4. Bind and generate the localized configuration files into the codebase structure:

   ```bash
   flutterfire configure
   ```

### 8. Local Release Properties Setup (Android)

To enable production compilation capabilities on Android platforms, append an explicit credential file named `key.properties` inside the `android/app/` subdirectory containing your keystore parameters:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=<your-key-alias>
storeFile=<path-to-your-keystore>
```

> ⚠️ **Note:** The Android build script configuration enforces a hard validation ruleset and will strictly crash the build execution if these keystore properties are missing.

### 9. Native Configuration (Android)

Populate your valid Facebook identity metadata parameters inside `android/app/src/main/res/values/facebook_config.xml`:

```xml
<resources>
     <string name="facebook_app_id">*********</string>
     <string name="facebook_client_token">***********</string>
     <string name="fb_login_protocol_scheme">fb************</string>
</resources>
```

### 10. Native Configuration (iOS)

Inject your corresponding configuration markers directly inside your local `ios/Runner/Info.plist` layout parameters:

```xml
<key>CFBundleURLTypes</key>
<array>
     <dict>
          <key>CFBundleURLSchemes</key>
          <array>
               <string>fb(your_app_id)</string> </array>
     </dict>
</array>

<key>FacebookAppID</key>
<string>your_app_id</string>

<key>FacebookClientToken</key>
<string>your_client_token</string>
```

### 11. Flutter Impeller Rendering Setup

If you plan to run or profile the iOS presentation environment utilizing the Impeller graphic rendering framework engine, completely remove or comment out the forcing toggle flag inside the `ios/Runner/Info.plist` file:

```xml
<key>FLTEnableImpeller</key>
<false/>
```

### 12. Envied Generator Setup (Environment Secrets)

The project uses `envied` to securely handle and obfuscate local environment keys (such as the Google Books API Key).

1. Create a `.env` file at the root directory of the project:

   ```plaintext
   GOOGLE_BOOKS_API_KEY=YOUR_KEY
   ```

2. Run the `build_runner` environment scripts to clean any stale cache and generate the immutable obfuscated Dart configurations:

   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🚀 Launching the App

Once all configuration steps and dependencies are fully resolved and your local device/emulator connection is ready, fetch the package configurations and start compilation from the terminal window:

```bash
flutter pub get
flutter run
```

---

## 📖 Additional Documentation and Framework Resources

For a deep dive into the operational frameworks and architecture bindings running inside Bookify, feel free to reference the official technology platforms:

- [Flutter Official Ecosystem Framework Documentation](https://flutter.dev/docs)
- [Dart Language Paradigm Programming Guide](https://dart.dev/guides)
- [Firebase Platform Backend Execution Guides](https://firebase.google.com/docs)
- [SQLite Database Architecture Structure Documentation](https://www.sqlite.org/docs.html)
- [BLoC Pattern Lifecycle and State Library Implementations](https://bloclibrary.dev/#/)
- [Provider Inversion of Control Toolset Manual](https://pub.dev/packages/provider)

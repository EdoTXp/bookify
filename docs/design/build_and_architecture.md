# Build and Architecture

Welcome to the documentation for the Build and Architecture of the Bookify project. This document provides an overview of the project's structure, design principles, and the used technologies.

## Table of Contents

1. Introduction
2. Project Structure
3. Design Principles
4. Used Technologies
5. Build Process
6. Conclusion

## Introduction

Bookify is a mobile application designed to simplify the management and discovery of books.
The primary goal of the project is to provide users with an intuitive platform to organize their reading habits, explore recommendations, and track progress.
This document outlines the core structure and design principles that underpin the application, offering insights into the decisions that guided its development.

## Project Structure

The Bookify project follows a modular and scalable architecture, organizing its code into directories based on functionality. Below is an overview of the main directories and their purposes:

### Root Directories

- **integration_test/**: Contains integration tests that verify the complete application workflow.

- **lib/**: The main directory containing the source code of the application.

- **test/**: Houses unit tests to ensure individual components work as expected.

### Inside the lib Directory

- **src/**: The core source code is organized here for modular development. It contains:

- **core/**: Foundational elements and shared resources:

  - **adapters/**: Abstraction layers for adapting different data sources.
  - **database/**: Handles data storage and database interactions.
  - **dtos/**: Data Transfer Objects used for communication between layers.
  - **errors/**: Definitions of custom exceptions and error handling mechanisms.
  - **helpers/**: Utility classes and functions that aid in various operations.
  - **models/**: Defines the data structures used across the application.
  - **repositories/**: Manages data retrieval and storage logic.
  - **rest_client/**: Handles API interactions.
  - **services/**: Business logic and application services.
  - **storage/**: Manages file storage or persistent local data.

- **features/**: Contains the modularized code for each feature of the application. Each feature is implemented as an isolated module with its own structure, typically following this pattern:

  - **Feature Name (e.g., auth/)**:
    - **bloc/**: Contains the logic for state management using the BLoC (Business Logic Component) pattern. For example:
      - **auth_bloc.dart**: Defines the main BLoC for managing the feature's state and events.
      - **auth_bloc_event.dart**: Specifies the events that the BLoC responds to.
      - **auth_bloc_state.dart**: Defines the various states of the feature.
    - **views/**: Contains the UI components for the feature, such as pages or screens:
      - **auth_page.dart**: The main page or screen for the feature.
      - **widgets/**: Includes reusable widgets specific to the feature.

  ### Example Structure

  For the auth feature:

  ```plaintext
  features/
    └── auth/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_bloc_event.dart
    │   └── auth_bloc_state.dart
    ├── views/
        └── auth_page.dart
        └── widgets/  # Widgets specific to auth feature
  ```

- **shared/**: Contains global resources and components shared across multiple features:
  - **blocs/**: Global business logic components using the BLoC (Business Logic Component) pattern.
  - **constants/**: Stores global constants for reuse across the project.
  - **providers/**: Handles global state management and dependency injection.
  - **routes/**: Defines the application's navigation routes.
  - **theme/**: Manages the application's themes and styling.
  - **widgets/**: Includes reusable widgets shared by multiple features.
- **bookify_app.dart**: The entry point for initializing the application.
- **main.dart**: The main entry point of the application.

## Design Principles

The project follows the principle of separation of concerns, organizing the code in a modular and scalable way. The main structure is based on the following concepts:

- **View**: The view is responsible for presenting data to the user and handling user interactions. The view communicates with the BLoC to get data and send events.
- **BLoC (Business Logic Component)**: The BLoC manages the business logic and state of the application. It receives events from the view, processes data through services, and updates the state observed by the view.
- **Service**: Services contain the business logic of the application. They interact with repositories to retrieve and save data.
- **Repository**: Repositories handle data access, both local and remote. They provide an interface for data access and hide implementation details.
- **DTO (Data Transfer Object)**: DTOs are objects used to transfer data between different layers of the application. They help keep domain models separate from presentation models.
- **Model**: Models represent the data structures used in the application. They can be used in both repositories and services.
- **Provider**: Providers manage dependency injection, facilitating the creation and management of objects needed in various layers of the application.

This architecture ensures a clear separation of concerns, making the codebase easier to maintain and extend.

## Used Technologies

The Bookify project utilizes the following main technologies and frameworks:

- **Flutter**: The primary framework used for building the cross-platform mobile application.
- **Dart**: The programming language used in conjunction with Flutter for developing the application.
- **Firebase**: Provides backend services such as authentication, database, and cloud storage.
- **SQLite**: Used for local data storage and offline capabilities.
- **BLoC (Business Logic Component)**: A state management library that helps separate business logic from UI components.
- **Provider**: A dependency injection and state management library used for managing app-wide states.

## Build Process

Follow these steps to clone the Bookify project and set up authentication for both Android and iOS. This guide also covers integrating Firebase Authentication, Facebook, Google, and Apple login, as well as configuring release settings for Android.

### 1. Clone the Project

To clone the Bookify project, run the following command:

```bash
git clone https://github.com/EdoTXp/bookify
```

### 2. Firebase Authentication Setup

#### Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project and add both your Android and iOS apps to the project.

#### Enable Authentication Services

1. Navigate to Authentication in Firebase Console.
2. Enable the following authentication services:
   - Google Authentication for Android
   - Facebook Authentication for both Android and iOS
   - Apple Authentication for iOS

For more details, see the official documentation:

- [Facebook Login Setup for Android](https://developers.facebook.com/docs/facebook-login/android)
- [Facebook Login Setup for iOS](https://developers.facebook.com/docs/facebook-login/ios)
- [Google Sign-In Setup](https://developers.google.com/identity/sign-in/android/start-integrating)
- [Apple Sign-In Setup](https://developer.apple.com/documentation/sign_in_with_apple)

### 3. OpenSSH Setup

1. Install OpenSSH.
2. Follow the steps to create an App ID and secret code for Facebook, and then use OpenSSH to create the necessary tokens.

For more information on using OpenSSH, refer to the [OpenSSH Documentation](https://www.openssh.com/manual.html).

### 4. Facebook Login Setup

#### Facebook App Configuration

1. Go to [Facebook Developer Portal](https://developers.facebook.com/).
2. Create a new app and configure Facebook Login for both Android and iOS.
3. Follow the official guides for each platform:
   - [Facebook Login for Android](https://developers.facebook.com/docs/facebook-login/android)
   - [Facebook Login for iOS](https://developers.facebook.com/docs/facebook-login/ios)

#### Add Facebook Credentials to Firebase

After configuring Facebook login, go to Firebase Console, and in the Authentication section, add the App ID and App Secret for Facebook in the Authentication Access Methods.

### 5. Generate SHA-1 and SHA-256 for Google Login

For Android, generate SHA-1 and SHA-256 fingerprints for both debug and release builds.

#### Generate Debug SHA-1 and SHA-256

Run the following command:

```bash
keytool -list -v -keystore <path-to-your-keystore> -alias <key-alias> -storepass <keystore-password> -keypass <key-password>
```

#### Generate Release SHA-1 and SHA-256

Follow the instructions in these guides:

- [Android App Signing Guide](https://developer.android.com/studio/publish/app-signing)
- [Google Client Authentication Guide](https://developers.google.com/identity/sign-in/android/start-integrating)

### 6. Configure Apple Authentication

This project does not support Apple Sign-In due to the lack of an Apple Developer ID. However, if you wish to implement it, follow the official [Apple Sign-In Documentation](https://developer.apple.com/documentation/sign_in_with_apple), and configure the credentials in Firebase.

### 7. Install Node.js and Firebase Tools

1. Install [Node.js](https://nodejs.org/).
2. Install Firebase CLI:

   ```bash
   npm install -g firebase-tools
   ```

3. Log in to Firebase:

   ```bash
   firebase login
   ```

4. Install FlutterFire CLI:

   ```bash
   dart pub global activate flutterfire_cli
   ```

5. Configure Firebase in your project:

   ```bash
   flutterfire configure
   ```

### 8. Android Release Setup

To generate an Android release, add the release key in the `key.properties` file located in the `android/app` directory:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=<your-key-alias>
storeFile=<path-to-your-keystore>
```

### 9. Facebook Configuration for Android

In `android/app/src/res/values/facebook_config.xml`, add the following Facebook credentials:

```xml
<resources>
     <string name="facebook_app_id">*********</string>
     <string name="facebook_client_token">***********</string>
     <string name="fb_login_protocol_scheme">fb************</string>
</resources>
```

### 10. Facebook Configuration for iOS

In `ios/Runner/Info.plist`, make the following changes:

```xml
<key>CFBundleURLSchemes</key>
<array>
     <string>fb(your app id)</string> <!-- Do not include the parentheses -->
</array>

<key>FacebookAppID</key>
<string>your app id</string>

<key>FacebookClientToken</key>
<string>your token</string>
```

### 11. Flutter with Impeller

If you wish to run Flutter with Impeller, remove or comment out the following line in `ios/Runner/Info.plist`:

```xml
<key>FLTEnableImpeller</key>
<false/>
```

For more details, always refer to the official documentation.

## Conclusion

In conclusion, the Bookify project is structured to ensure modularity and scalability, following best practices in software architecture. The project is organized into clear directories, each serving a specific purpose, from core functionalities to feature-specific implementations. The design principles emphasize separation of concerns, making the codebase maintainable and extensible. Key technologies such as Flutter, Dart, Firebase, SQLite, BLoC and Provider are utilized to build a robust and efficient application.

For further reading and additional resources, consider the following:

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [BLoC Library](https://bloclibrary.dev/#/)
- [Provider Package](https://pub.dev/packages/provider)

These resources provide comprehensive guides and references to help you understand and leverage the technologies used in the Bookify project.

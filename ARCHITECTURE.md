# Project Architecture - Bookify

Welcome to the official architectural documentation for Bookify. This document outlines the project's structural design, unidirectional data flow rules, directory layouts, and foundational design choices ensuring long-term scalability and clean separation of concerns.

---

## 🏛️ Architectural Principles

Bookify adopts a **Pragmatic Clean Architecture** approach tailored for modern Flutter ecosystems. The system is designed around a strict inversion of dependencies layout, ensuring that core business expectations (the Domain layer) remain pure Dart code, completely decoupled from database frameworks, network providers, or third-party presentation implementations.

### Unidirectional Data Pipeline

Every feature flow or asynchronous routine to the following sequence:  
**View (UI) ➔ BLoC (State) ➔ Service (Business Workflow) ➔ Repository (Data Abstraction) ➔ Data Layer (Infrastructure)**

Data Layer implementations:

- Remote Data Sources for external APIs (e.g. Google Books API)
- Local Database persistence using SQLite
- Local Storage persistence using SharedPreferences

---

## 📂 Codebase Directory Layout (`lib/src/`)

The core architecture isolates features into dedicated presentation modules while centralizing underlying database configurations and infrastructure.

```plaintext
lib/src/
├── core/                          # Cross-cutting foundational layer (Infrastructure only)
│   ├── config/                    # Global environment configurations and constants
│   ├── enums/                     # Global Enums
│   ├── errors/                    # Centralized custom Exceptions
│   ├── extensions/                # Dart/Flutter extension utilities (e.g., BuildContext)
│   └── helper/                    # Pure utility functions and general helpers
│
├── data/                          # DATA LAYER: Low-level I/O & Infrastructure implementations
│   ├── adapters/                  # Data mapping logic and architectural adapters
│   ├── data_sources/              # Concrete remote API clients (Google Books)
│   ├── database/                  # SQLite native configuration
│   ├── repositories/              # Concrete data handling (Bundled Interfaces + Implementations)
│   ├── rest_client/               # Dio network client setup, interceptors, and headers
│   └── storage/                   # SharedPreferences/File local key-value stores
│
├── domain/                        # DOMAIN LAYER: Pure Application Business Rules
│   ├── dtos/                      # Composite models / Data aggregates optimized for DB JOIN operations
│   ├── models/                    # Core application entities and business domain models
│   └── services/                  # Business services orchestrating workflow logic
│
├── features/                      # PRESENTATION LAYER: Independent Feature Modules
│   └── [feature_name]/            # Example: auth, reading, shelf
│       ├── bloc/                  # Business Logic Components (Bloc, Event, State files)
│       └── views/                 # UI implementation (Pages and module-specific widgets)
│
└── shared/                        # Shared UI components, assets, and styling singletons
    ├── blocs/                     # Global app-wide state units (e.g., ThemeBloc)
    ├── constants/                 # Fixed asset tokens, iconography keys, and layout tokens
    ├── providers/                 # Dependency Injection engine powered by Provider
    ├── routes/                    # Centralized navigator routing tables
    ├── theme/                     # Design system configurations and color schemes
    └── widgets/                   # Atomic, highly reusable presentation components (buttons, custom cards)
```

---

## 🛠️ Layer Responsibilities & Pragmatic Decisions

### 1. View & BLoC (Presentation Layer)

The UI consists of pure stateless or stateful widgets. User actions trigger immutable Event signals sent to the corresponding BLoC. The BLoC processes these incoming intents by dispatching them to the correct domain/service, subsequently yielding a predictable State which the View listens to for UI updates.

### 2. Services (Domain Layer)

Services handle pure application workflows. They encapsulate how business features behave without ever knowing where data comes from. Services consume required information by invoking interfaces on repositories.

### 3. Models and DTOs (Domain Layer)

To prevent heavy object-mapping overhead (`Entity` ➔ `Model` ➔ `DataDto` duplicate files), Bookify implements a clean compromise:

- **`domain/models/`**: Holds core application structure records used uniformly across every single architecture boundary.
- **`domain/dtos/`**: Dedicated to **Composite Models (Aggregates)**. These are defined inside the domain layer because they represent specific business mutations (e.g., merging a book object with its underlying read-tracker state via an SQLite `JOIN` query), consumed directly by services and presentation structures.

---

## 🚀 Used Technologies

The Bookify ecosystem leverages a robust stack of libraries and tools to ensure offline capability, secure authentication, and a high-fidelity user experience.

### Core Architecture & State Management

- **Flutter & Dart**: Core cross-platform application framework and programming language.
- **State Management (`flutter_bloc`)**: Enforces a strict, predictable event-driven state management pattern to decouple business logic from the UI.
- **Dependency Injection (`provider`)**: Manages compile-time scopes and injects service/repository instances cleanly down the widget tree.

### Backend & Identity Providers

- **Firebase Core Suite (`firebase_core`, `firebase_auth`)**: Handles core backend coordination and remote authentication management.
- **Social Authentication Engines**: Fully integrates native federated identity streams via `google_sign_in`, `flutter_facebook_auth`, and `sign_in_with_apple`.

### Data Networking & Persistence

- **HTTP Client (`dio` & `dio_cache_interceptor`)**: Powers efficient remote REST API interactions with the Google Books API, backed by an explicit caching layer to save bandwidth.
- **Local Database (`sqflite` & `path`)**: Implements a dedicated embedded SQLite engine to manage bookshelves, offline data, and reading logs seamlessly.
- **Key-Value Storage (`shared_preferences`)**: Handles lightweight persistence for user settings and local app configurations.

### Hardware Integration & Native Features

- **Barcode Scanner (`mobile_scanner`)**: Accesses the device camera to perform high-speed ISBN barcode scanning.
- **Media Playback (`audioplayers`)**: Directs native system audio channels to trigger alarm ringtones during reading sessions.
- **Screen Display Management (`wakelock_plus`)**: Overrides native OS power-saving timeouts to keep the screen awake during active reading timers.
- **Contacts & Permissions (`fast_contacts`, `permission_handler`)**: Requests operating system level permissions to safely retrieve user contacts.

### Notifications & Local Time handling

- **Scheduling Engine (`flutter_local_notifications`)**: Manages rich local alerts and platform-specific background delivery notifications.
- **Timezone Utilities (`timezone`, `flutter_timezone`, `intl`)**: Decodes exact localized timezones and formats date-time records to schedule precise, region-aware notifications.

### Security & Environment Setup

- **Secrets Management (`envied` & `envied_generator`)**: Obfuscates and injects sensitive API keys and environment secrets directly into binary code during compilation.
- **Cryptographic Utilities (`crypto`)**: Generates SHA-256 secure cryptographic hashes required for identity verification flows.

### Testing & Automation (Development)

- **Integration UI Testing (`patrol`)**: Drives full end-to-end automated UI testing workflows across physical devices or emulators.
- **Unit Testing & Mocking (`mocktail`, `bloc_test`)**: Validates independent class models and business state changes under completely controlled mock layers.

---

## 📖 Conclusion

Bookify is engineered with modular design mechanics at its core. By detaching volatile I/O frameworks from foundational business expectations, the codebase remains highly adaptable, easier to test, and ready to evolve as the application scales.

# Bookify - GitHub Copilot Instructions

**Purpose**: These instructions guide GitHub Copilot in generating code that aligns with Bookify's architecture, best practices, and project standards.

---

## Quick Project Overview

**Bookify** is a cross-platform Flutter mobile application for managing personal book libraries with features including:

- Book discovery via Google Books API
- Personal bookcase management with offline SQLite support
- Reading progress tracking and reading timers
- Social features (contacts, loans, notifications)
- Multi-auth support (Firebase with Google, Facebook, Apple login)

**Tech Stack**: Flutter 3.10+, Dart 3.10+, Firebase (auth), SQLite (sqflite), Provider (DI), BLoC (state management).

**Architecture**: Pragmatic Clean Architecture with layer separation → View ➔ BLoC ➔ Service ➔ Repository ➔ Data Sources.

---

## Before Code Generation: MANDATORY Checklist

**ALWAYS complete this checklist before asking Copilot to generate code:**

1. ✅ **Read Documentation First**
   - Read `ARCHITECTURE.md` and `BUILD.md` completely.
   - Review `/docs/design/` for design specs and understand the feature requirements.

2. ✅ **Understand the Architecture Layout**
   - Know which layer your code belongs to (`core`, `data`, `domain`, or `features`).
   - Verify that dependencies flow inward only: Presentation/Features depend on Domain/Data, Data depends on Domain contracts, and Domain remains pure Dart code.

3. ✅ **Check Existing Code**
   - Search for similar features already implemented.
   - Review existing BLoCs, Services, and Repositories to follow established patterns and naming conventions.

4. ✅ **Verify Correct Layer for Services & Infrastructure**
   - **`domain/services/`** = Pure application business workflows (orchestrate logic, can call Repository interfaces).
   - **`core/` or App Wrappers** = OS-level or low-level technical infrastructure (camera, permissions, notifications) → DO NOT mix with pure domain logic.

5. ✅ **Check Project Structure**
   - Verify file is in the correct location.
   - Confirm naming follows `snake_case` for files and `PascalCase` for classes.
   - Feature structure must follow: `lib/src/features/[feature_name]/bloc/` and `views/`.

---

## Project Structure (Reference)

```plaintext
lib/src/
├── core/                          # Cross-cutting foundational layer (Infrastructure only)
│   ├── config/                    # Global environment configurations and constants
│   ├── enums/                     # Global technical and shared error-related Enums
│   ├── errors/                    # Centralized custom Exceptions and error management
│   ├── extensions/                # Dart/Flutter extension utilities (e.g., BuildContext)
│   └── helper/                    # Pure utility functions and general helpers
│
├── data/                          # DATA LAYER: Low-level I/O & Infrastructure implementations
│   ├── adapters/                  # Data mapping logic and architectural adapters
│   ├── data_sources/              # Concrete remote API clients (Firebase, Google Books, etc.)
│   ├── database/                  # SQLite native configuration, schemas, and DAO layers
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
    └── widgets/                   # Atomic, highly reusable presentation components
```

---

## SOLID Principles & Design Patterns (MANDATORY)

**You MUST follow these principles:**

### Single Responsibility Principle

- One class = one reason to change.
- Repository only handles data access; Service only handles business workflows; BLoC only handles UI state and events.

### Open/Closed Principle

- Extend through inheritance/interfaces, don't modify existing concrete stable classes.

### Dependency Inversion Principle

- Depend on abstractions, not concrete implementations.
- Inject dependencies via Provider or constructors. Never hardcode instance creation inside layers.

**Design Patterns Used**:

- **BLoC Pattern**: State management via `flutter_bloc`.
- **Repository Pattern**: Structural abstract data access layer.
- **DTO Pattern**: Composite objects (`domain/dtos/`) optimized for database JOIN mutations, separating low-level rows from strict domain models.

---

## Code Style Standards (MANDATORY)

### Naming Conventions

```
❌ DON'T                          ✅ DO
f()                               fetchUserBooks()
UserRepo                          UserRepository
CONSTANT_VALUE                    kMaxRetries or maxRetries
fetch_data.dart                   fetch_data.dart (snake_case)
FetchData                         FetchData (PascalCase for classes)
```

### Dart/Flutter Best Practices

**ALWAYS**:

- Use `const` constructors wherever possible for widget performance.
- Prefer `final` over `var` or `dynamic`.
- Add `///` documentation comments to public methods and services.
- Keep functions short and extracted (ideally under 30 lines).
- Max line length: 80 characters.

**NEVER**:

- Create circular dependencies between layers.
- Hardcode API endpoints or sensitive credential keys (use `Envied` obfuscation profiles).
- Use `dynamic` type mappings blindly.

---

## Services Layer: Critical Distinction

### OS-Level / Technical Infrastructure Wrappers

**Purpose**: Direct hardware/native API plugins managed inside technical layers (e.g., `mobile_scanner`, `fast_contacts`, `flutter_local_notifications`).
**Characteristics**:

- Contains direct wrapper or device setup calls.
- ❌ DO NOT inject business repositories or database entities here.

### Business Logic Services (`domain/services/`)

**Purpose**: Encapsulates core application business validation routines and features.
**Characteristics**:

- ✅ MAY interact with repositories to retrieve and save domain states.
- ❌ DO NOT embed any View, BuildContext, or UI widget dependencies.

---

## Build & Validation Commands

**Run these commands to validate local developments:**

```bash
# Analyze code for lint issues
flutter analyze

# Run all unit and bloc tests
flutter test

# Format code (Dart standard)
dart format lib/

# Run app on connected device/emulator
flutter run

# Build release artifacts
flutter build apk --release
```

---

## Technology Versions (Reference to pubspec)

```plaintext
Flutter SDK:  >=3.10.0 <4.0.0
Dart SDK:     >=3.10.0 <4.0.0
dio:          ^5.9.2
flutter_bloc: ^9.1.1
provider:     ^6.1.5+1
sqflite:      ^2.4.3
firebase_core:^4.11.0
firebase_auth:^6.5.4
envied:       ^1.3.5
```

---

## Copilot Best Practices

### ✅ DO

- **Be highly specific**: "Create a Repository interface for books inside data/repositories/ with a method searchBooks(String query)".
- **Reference layout design**: "Follow the pragmatic Clean Architecture setup, ensuring models map smoothly from the data layer to domain entities".
- **Ask for tests**: "Generate corresponding unit tests using mocktail and bloc_test patterns".

### ❌ DON'T

- Request structural changes across multiple architecture layers at once.
- Skip the documentation checks or mix domain models with external JSON contracts directly.

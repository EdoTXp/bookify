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

**Tech Stack**: Flutter 3.x, Dart 3.0.2+, Firebase (auth/Firestore), SQLite, Provider (DI), BLoC (state management)

**Architecture**: Clean Architecture with layered separation → View → BLoC → Service → Repository → Data Sources

---

## Before Code Generation: MANDATORY Checklist

**ALWAYS complete this checklist before asking Copilot to generate code:**

1. ✅ **Read Documentation First**

   - Read `/design/documentation/build_and_architecture.md` completely
   - Review `/design/documentation/` for design specs
   - Understand the feature requirements

2. ✅ **Understand the Architecture**

   - Know which layer your code belongs to (View/BLoC/Service/Repository/DTO/Model)
   - Understand the View → BLoC → Service → Repository flow
   - Verify dependencies flow inward only (never outward)

3. ✅ **Check Existing Code**

   - Search for similar features already implemented
   - Review existing BLoCs, Services, Repositories
   - Follow established patterns and naming conventions

4. ✅ **Verify Correct Layer for Services**

   - **`core/services/app_services/`** = OS-level services (camera, contacts, permissions, notifications) → DO NOT call repositories
   - **`core/services/`** = Business logic services → MAY call repositories
   - Understand the distinction before requesting code

5. ✅ **Check Project Structure**
   - Verify file is in correct location
   - Confirm naming follows `snake_case` for files, `PascalCase` for classes
   - Feature structure must follow: `features/[feature_name]/bloc/`, `views/`, `widgets/`

---

## Project Structure (Reference)

```
lib/src/
├── core/                          # Foundational layer
│   ├── adapters/                  # Data source abstraction
│   ├── data_sources/              # API/local data implementations
│   ├── database/                  # SQLite setup
│   ├── dtos/                      # Data Transfer Objects
│   ├── errors/                    # Custom exceptions
│   ├── helpers/                   # Utility functions
│   ├── models/                    # Core data structures
│   ├── repositories/              # Data access interfaces
│   ├── rest_client/               # HTTP client (Dio)
│   ├── services/
│   │   ├── app_services/          # Android/iOS services (NO repositories)
│   │   └── [business_services]    # Business logic (MAY call repositories)
│   ├── storage/                   # File storage
│   └── utils/                     # General utilities
│
├── features/                      # Feature modules (isolated)
│   ├── [feature_name]/
│   │   ├── bloc/                  # State management
│   │   │   ├── [feature]_bloc.dart
│   │   │   ├── [feature]_event.dart
│   │   │   └── [feature]_state.dart
│   │   └── views/
│   │       ├── [feature]_page.dart
│   │       └── widgets/           # Feature-specific widgets
│
└── shared/                        # Global resources only
    ├── blocs/                     # Global state
    ├── constants/                 # Global constants
    ├── providers/                 # Global DI/providers
    ├── routes/                    # Navigation
    ├── theme/                     # App styling
    └── widgets/                   # Reusable widgets
```

**CRITICAL**: Features must NOT import from each other. Use shared widgets and providers for cross-feature communication.

---

## SOLID Principles & Design Patterns (MANDATORY)

**You MUST follow these principles:**

### Single Responsibility Principle

- One class = one reason to change
- Repository only handles data access
- Service only handles business logic
- BLoC only handles state and events

### Open/Closed Principle

- Extend through inheritance/interfaces, don't modify existing classes
- Use abstract classes in `core/repositories/` for contracts

### Liskov Substitution Principle

- All implementations must be substitutable for their interfaces
- Never break expected behavior in derived classes

### Interface Segregation Principle

- Don't force unnecessary dependencies
- Create specific interfaces, not fat interfaces

### Dependency Inversion Principle

- Depend on abstractions (interfaces), not concrete implementations
- Inject dependencies via Provider or constructor
- Never hardcode instance creation

**Design Patterns Used**:

- **BLoC Pattern**: State management (always use flutter_bloc)
- **Repository Pattern**: Abstract data access layer
- **Singleton**: For services via Provider
- **Factory**: Provider creates BLoCs/services
- **Adapter Pattern**: `core/adapters/` for data source abstraction
- **DTO Pattern**: Transform data between layers

---

## Code Style Standards (MANDATORY)

### Naming Conventions

```
❌ DON'T                          ✅ DO
f()                               fetchUserBooks()
UserRepo                          UserRepository
userName                          userName (same, correct)
CONSTANT_VALUE                    kMaxRetries or maxRetries
fetch_data.dart                   fetch_data.dart (snake_case)
FetchData                         FetchData (PascalCase for classes)
```

### Dart/Flutter Best Practices

**ALWAYS**:

- Use `const` constructors for performance
- Prefer `final` over `var` or `dynamic`
- Use null safety properly (`?`, `!`, `??`)
- Add `///` documentation comments to public methods
- Keep functions under 30 lines (extract larger functions)
- Import organization: dart, flutter, packages, relative (in order)
- Max line length: 80 characters (Flutter standard)

**NEVER**:

- Use `var` for public return types (be explicit)
- Create circular dependencies between layers
- Hardcode API endpoints or sensitive data
- Ignore errors without logging
- Use `dynamic` type
- Deep nesting (max 3-4 levels)

### Example: Correct Pattern for Repository

```dart
abstract class BookRepository {
  Future<List<Book>> searchBooks(String query);
  Future<Book?> getBookById(String id);
}

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl(this._restClient, this._database);

  final RestClient _restClient;
  final AppDatabase _database;

  @override
  Future<List<Book>> searchBooks(String query) async {
    try {
      final dtos = await _restClient.getBooks(query);
      final books = dtos.map((dto) => dto.toModel()).toList();
      await _database.insertBooks(books);
      return books;
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Unknown error');
    }
  }
}
```

### Example: Correct Pattern for Service

```dart
class BookSearchService {
  BookSearchService(this._bookRepository);

  final BookRepository _bookRepository;

  Future<List<Book>> searchAndFilterBooks(String query) async {
    final books = await _bookRepository.searchBooks(query);
    // Business logic: filter by rating
    return books.where((book) => book.rating >= 3.0).toList();
  }
}
```

### Example: Correct Pattern for BLoC

```dart
class BookSearchBloc extends Bloc<BookSearchEvent, BookSearchState> {
  BookSearchBloc(this._bookSearchService) : super(BookSearchInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
  }

  final BookSearchService _bookSearchService;

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<BookSearchState> emit,
  ) async {
    emit(BookSearchLoading());
    try {
      final books = await _bookSearchService.searchAndFilterBooks(event.query);
      emit(BookSearchSuccess(books));
    } on ApiException catch (e) {
      emit(BookSearchError(e.message));
    }
  }
}
```

---

## Services Layer: Critical Distinction

### OS-Level Services (`core/services/app_services/`)

**Purpose**: Wrapper around Android/iOS native features

**Characteristics**:

- Direct device API calls only
- ❌ DO NOT call any repository
- ❌ DO NOT access databases
- ❌ DO NOT contain business logic

**Examples**:

```dart
// ✅ CORRECT: Direct Android/iOS API
class CameraService {
  Future<bool> requestCameraPermission() async {
    return (await Permission.camera.request()).isGranted;
  }
}

// ✅ CORRECT: Device notifications
class NotificationService {
  Future<void> showNotification(String title, String body) async {
    await _flutterLocalNotificationsPlugin.show(/*...*/);
  }
}
```

### Business Logic Services (`core/services/`)

**Purpose**: Application business logic

**Characteristics**:

- ✅ MAY call repositories
- ✅ Contain domain business logic
- ✅ Used by BLoCs
- ❌ DO NOT access views/UI

**Examples**:

```dart
// ✅ CORRECT: Business service calling repository
class BookSearchService {
  Future<List<Book>> searchBooks(String query) async {
    final books = await _bookRepository.searchBooks(query);
    return books.where((b) => b.rating > 3.0).toList();
  }
}

// ✅ CORRECT: Authentication service
class AuthService {
  Future<User> loginWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }
}
```

---

## Build & Validation Commands

**Run these to validate your code** (use before requesting code generation):

```bash
# Analyze code for lint issues
flutter analyze

# Run all tests
flutter test

# Format code (Dart standard)
dart format lib/

# Run app on connected device/emulator
flutter run

# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release
```

**Expected Results**:

- `flutter analyze` → 0 issues
- `flutter test` → All tests pass ✓
- `dart format` → No changes (code already formatted)
- `flutter run` → App launches without errors

---

## Known Issues & Workarounds

| Issue                           | Cause                        | Solution                                         |
|---------------------------------|------------------------------|--------------------------------------------------|
| Pod install fails on M1 Mac     | Arch mismatch                | `arch -x86_64 pod install` in `ios/`             |
| Firebase config not found       | Missing google-services.json | Run `flutterfire configure`                      |
| BLoC events not firing          | Wrong event type             | Verify event dispatched in exact state to listen |
| SQLite database locked          | Concurrent access            | Use `exclusive: true` in sqflite operations      |
| Image not loading from Firebase | Network issue or permission  | Check Firebase Storage rules and network         |

---

## Technology Versions (Reference)

```
Flutter SDK:  >=3.0.2 <4.0.0
Dart:         >=3.0.2 <4.0.0
Firebase:     v6.1.3+ (auth)
flutter_bloc: v9.1.1+
provider:     v6.1.5+
dio:          v5.9.0+
sqflite:      v2.4.2+
```

---

## Copilot Best Practices

### ✅ DO

- **Be specific**: "Create a Repository interface for books with methods: searchBooks(String query) → Future<List<Book>>" (good) vs. "Create a book repository" (vague)
- **Reference existing code**: "Follow the pattern used in auth_bloc.dart for state management"
- **Mention constraints**: "Use SOLID principles, specifically Single Responsibility Principle"
- **Ask for tests**: "Also generate unit tests using mocktail"
- **Describe error handling**: "Handle DioException and emit error state"

### ❌ DON'T

- Ask for code in multiple layers at once → Request one layer at a time
- Use vague terms → Be explicit about class names, parameters, return types
- Ignore the architecture → Always reference which layer code belongs to
- Skip the documentation checklist → Read design docs first
- Ask for OS service as business service → Clarify the distinction

---

## Final Validation Before Coding

Ask yourself:

1. **Layer Check**: Is my code in the correct layer? (View/BLoC/Service/Repo/DTO)
2. **Architecture Check**: Does it follow the View → BLoC → Service → Repository → Data flow?
3. **Naming Check**: Is it `snake_case` for files, `PascalCase` for classes?
4. **Dependency Check**: Do dependencies flow inward only (never outward)?
5. **Pattern Check**: Does it follow an existing pattern in the codebase?
6. **Error Check**: Does it handle errors appropriately?
7. **Testing Check**: Can this be unit tested?
8. **Feature Isolation**: Is my feature independent (not importing other features)?

If you answer NO to any question, re-read this document and adjust your request.

---

**Remember**: Always start by reading `/design/documentation/build_and_architecture.md` for complete architectural understanding.

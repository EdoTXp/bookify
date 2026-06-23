# BOOKIFY

![Bookify Logo](docs/design/images/bookify.png)

**Bookify** is a cross-platform mobile application developed with Flutter, designed to help users organize their personal library, track reading progress, and manage book loans through a scalable, clean, and pragmatically designed architecture.

---

## 🎨 Design

The user interface design was fully crafted on [Figma](https://www.figma.com/file/EGg9eFK0Hi8LaVQcPVnjrX/Bookify-Edoardo?node-id=0%3A1).

---

## 🚀 Getting Started & Releases

If you just want to try out the app without compiling the source code, you can download the latest pre-compiled binaries directly from the **[Releases](https://github.com/EdoTXp/bookify/releases)** section of this repository. Alternatively, if you want to compile and run Bookify locally from the source code, please note that it requires specific configuration steps, environment keys, and toolchains due to the integration with external services (Firebase, Google Books API, Facebook Auth). You can find our comprehensive step-by-step setup instructions inside our dedicated guide:  
➔ 🔨 **[BUILD.md](BUILD.md)**

---

## 🛠️ Architecture Overview

The project is built upon a **Pragmatic Clean Architecture** layout to ensure high decoupling, testability, and clear separation of concerns.

The application layer flow follows a unidirectional pipeline:  
**View ➔ BLoC ➔ Service ➔ Repository**.

For a comprehensive breakdown of our directory layout, architectural decisions, and model definitions, check out our official design document:
➔ 📐 **[ARCHITECTURE.md](ARCHITECTURE.md)**.

---

## ✨ Core Features

- **📙 Book Search**: Search for books by title, author, category, publisher, and ISBN via Google Books API. Includes camera barcode scanning and manual entry.
- **🗄️ Custom Bookshelves**: Create and manage virtual shelves with custom names and colors to easily organize and categorize your offline collection.
- **📚 My Books**: A dedicated, unified space to view your entire collection of saved books at a single glance.
- **🤝 Loans**: Complete management of books loaned to contacts. Track loan dates, expected return dates, and contact information.
- **📖 Readings & Timer**: Track active reading progress with an integrated session timer and a manual page-count updater.
- **⚙️ Settings**: Customize app behavior: theme management (Light/Dark/System), reading speed calibration, and daily reminders.

### 📸 Interface Gallery

#### 🤖 Android

|                                                        |                                                        |                                                        |                                                        |
| :----------------------------------------------------: | :----------------------------------------------------: | :----------------------------------------------------: | :----------------------------------------------------: |
|  ![Screenshot 1](docs/design/images/Screenshot_1.png)  |  ![Screenshot 2](docs/design/images/Screenshot_2.png)  |  ![Screenshot 3](docs/design/images/Screenshot_3.png)  |  ![Screenshot 4](docs/design/images/Screenshot_4.png)  |
|  ![Screenshot 5](docs/design/images/Screenshot_5.png)  |  ![Screenshot 6](docs/design/images/Screenshot_6.png)  |  ![Screenshot 7](docs/design/images/Screenshot_7.png)  |  ![Screenshot 8](docs/design/images/Screenshot_8.png)  |
|  ![Screenshot 9](docs/design/images/Screenshot_9.png)  | ![Screenshot 10](docs/design/images/Screenshot_10.png) | ![Screenshot 11](docs/design/images/Screenshot_11.png) | ![Screenshot 12](docs/design/images/Screenshot_12.png) |
| ![Screenshot 13](docs/design/images/Screenshot_13.png) | ![Screenshot 14](docs/design/images/Screenshot_14.png) | ![Screenshot 15](docs/design/images/Screenshot_15.png) | ![Screenshot 16](docs/design/images/Screenshot_16.png) |
| ![Screenshot 17](docs/design/images/Screenshot_17.png) | ![Screenshot 18](docs/design/images/Screenshot_18.png) | ![Screenshot 19](docs/design/images/Screenshot_19.png) | ![Screenshot 20](docs/design/images/Screenshot_20.png) |
| ![Screenshot 21](docs/design/images/Screenshot_21.png) | ![Screenshot 22](docs/design/images/Screenshot_22.png) | ![Screenshot 23](docs/design/images/Screenshot_23.png) | ![Screenshot 24](docs/design/images/Screenshot_24.png) |
| ![Screenshot 25](docs/design/images/Screenshot_25.png) | ![Screenshot 26](docs/design/images/Screenshot_26.png) | ![Screenshot 27](docs/design/images/Screenshot_27.png) | ![Screenshot 28](docs/design/images/Screenshot_28.png) |

#### 🍎 iOS

[iOS Screenshots](docs/design/images/ios/)

---

## 👥 Team & Credits

- **Fredson Costa** - _UI/UX Designer_ - [LinkedIn](https://www.linkedin.com/in/fredsoncosta/)
- **Edoardo Fabrizio De Iovanna** - _Developer_ - [LinkedIn](https://www.linkedin.com/in/edoardofabrizio/) / [Portfolio](https://edotxp.github.io/)

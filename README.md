# Reusable Flutter Project

A **production-ready Flutter starter template** built using **Clean Architecture, MVVM, and GetX**.
This project provides a **scalable, modular, and maintainable architecture** for building large Flutter applications with proper separation of concerns.

---

## 🚀 Tech Stack

* **Flutter (Dart)**
* **GetX** – State Management, Dependency Injection, Routing
* **Clean Architecture**
* **MVVM Pattern**
* **REST API Integration**
* **Feature-Based Modular Architecture**

---

## 🧠 Architecture Overview

This project follows a **feature-based Clean Architecture approach** combined with the **MVVM pattern**.

The application is divided into three main layers:

**Presentation Layer**

* UI screens
* Controllers (GetX)
* User interaction handling

**Domain Layer**

* Business logic
* Abstract repository contracts

**Data Layer**

* API calls
* Models
* Repository implementations

This architecture ensures:

* Clean code structure
* Better testability
* Scalability for large applications
* Easy maintenance

---

## 📂 Project Structure

```
lib
│
├── config
│   ├── bindings
│   │   └── theme
│   │       └── theme_binding.dart
│   │
│   └── routes
│       ├── app_routes.dart
│       └── main_page.dart
│
├── core
│   ├── config
│   │   └── localization
│   │       ├── app_translations.dart
│   │       ├── bn_bd.dart
│   │       ├── en_us.dart
│   │       └── localization_config.dart
│   │
│   ├── constants
│   │   ├── api_endpoints.dart
│   │   └── storage_keys.dart
│   │
│   ├── di
│   │   └── injection.dart
│   │
│   ├── error
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network
│   │   ├── interceptors
│   │   └── api_client.dart
│   │
│   ├── services
│   │
│   └── utils
│       ├── extensions
│       │   ├── context_extensions.dart
│       │   └── string_extensions.dart
│       │
│       ├── logger.dart
│       └── validators.dart
│
├── features
│   ├── auth
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   │
│   │   │   ├── models
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── login_response.dart
│   │   │   │   └── user_model.dart
│   │   │   │
│   │   │   └── repositories
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain
│   │   │   └── repositories
│   │   │       └── auth_repository.dart
│   │   │
│   │   └── presentation
│   │       ├── controllers
│   │       │   └── auth_controller.dart
│   │       │
│   │       └── pages
│   │           └── login_page.dart
│   │
│   ├── profile
│   └── settings
│
├── shared
│   └── widgets
│       ├── custom_bottom_nav.dart
│       ├── custom_button.dart
│       ├── empty_widget.dart
│       ├── error_widget.dart
│       ├── language_selector_widget.dart
│       └── loading_widget.dart
│
└── main.dart
```

---

## ✨ Key Features

* Feature-based modular architecture
* MVVM pattern implementation
* Clean separation of **data, domain, and presentation layers**
* Centralized API client with interceptors
* Dependency injection setup
* Multi-language localization support
* Reusable widgets and utilities
* Centralized error handling system
* Logging utilities

---

## 🌍 Localization

This project supports **multi-language localization**.

Supported languages:

* English (en_US)
* Bangla (bn_BD)

Localization files are located in:

```
core/config/localization
```

---

## 🔌 Network Layer

The project uses a **centralized API client** located in:

```
core/network/api_client.dart
```

Key features of the network layer:

* API interceptors
* Request / response logging
* Error handling
* Token-based authentication support

---

## 🧩 Feature Module Structure

Each feature follows the same structure:

```
feature_name
│
├── data
│   ├── datasources
│   ├── models
│   └── repositories
│
├── domain
│   └── repositories
│
└── presentation
    ├── controllers
    └── pages
```

This ensures **scalability and maintainability** for large applications.

---

## ▶️ Getting Started

Clone the repository

```
git clone https://github.com/Motasim-Fuad/MVVM_Architecture
```

Install dependencies

```
flutter pub get
```

Run the project

```
flutter run
```

---

## 👨‍💻 Author

**Motasim Fuad**
Flutter Developer

GitHub
https://github.com/Motasim-Fuad

LinkedIn
https://linkedin.com/in/motasim-fuad-27949b319

---

## 📄 License

This project is open-source and can be used for learning and development purposes.

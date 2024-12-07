# Lyxa Project Architecture Blueprint

## Lyxa Project Overview

The Lyxa Project is built using **Clean Architecture** principles, with **BLoC** and **Cubit** used for state management. This approach helps keep the application well organized, easy to maintain, and easy to test. The design focuses on making the app scalable and flexible.

## Key Concepts

### 1. Clean Architecture
Clean Architecture organizes the app into different layers, each with its own specific job. The goal is to keep the app independent of frameworks, the UI, databases, and external services. This separation makes the app easier to maintain and test.

### 2. BLoC (Business Logic Component)
BLoC is a design pattern used to manage state and handle business logic in a Flutter app. It separates the business logic from the user interface (UI) to keep the code cleaner and easier to manage.

### 3. Cubit
Cubit is a simpler version of BLoC. It reduces the amount of code needed by not using streams. Instead, Cubit focuses on managing state changes by calling methods that directly emit new states.

<br >

## Project Structure

```css
lib/
├──src/
│   ├── core/
│   │   ├── configs/        
│   │   ├── constants/
│   │   ├── dependency_injection/  
│   │   ├── services/  
│   │   ├── themes/     
│   │   ├── utils/          
│   │   └── validations/       
│   │  
│   ├── features/
│   │   ├── feature1/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── feature_model.dart
│   │   │   │   └── repositories/
│   │   │   │       ├── feature_repository_impl.dart
│   │   │   │       
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── feature_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── feature_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_data.dart
│   │   │   │       
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── feature_cubit.dart
│   │   │       │   │── feature_state.dart
│   │   │       ├── screens/
│   │   │       │   ├── feature_screen.dart
│   │   │       └── widgets/
│   │   │           ├── feature_widget.dart
│   │   │ 
│   │   ├── feature2.../
│   │   
│   ├── shared/
│   │   ├──  data/
│   │   ├──  handlers/
│   │   └──  widgets/
│   │   
│   ├── app.dart   
│   │  
└── main.dart
```
---
<br>

## Directory Breakdown

## core/
The `core` directory contains the essential building blocks for the whole app.

- **configs/**: Contains configuration files like API base URLs and third party services.
- **constants/**: Holds global constants that are used throughout the app.
- **dependency_injection/**: Manages dependency injection, typically using a library like `get_it`.
- **services/**: Contains classes that interact with external services like APIs or local databases.
- **themes/**: Defines global themes for consistent app styling.
- **utils/**: Reusable utility functions and helpers across the app.
- **validations/**: Includes validation logic for input fields and data integrity.

## features/
The `features` directory holds all the code specific to different features in the app, each in its own folder.

Each feature follows this structure:

- **data/**: Contains models and repositories for fetching data from remote or local sources.
  - **models/**: Data models that define the structure of objects returned from APIs or databases.
  - **repositories/**: Implementations of repositories that handle business logic for data fetching.
- **domain/**: Contains entities, use cases, and repository interfaces.
  - **entities/**: Core business objects representing data in the system.
  - **repositories/**: Abstract interfaces for repositories that interact with data.
  - **usecases/**: Specific operations, like fetching or updating data.
- **presentation/**: Contains all UI-related files, including state management, screens, and widgets.
  - **cubits/**: Holds Cubit classes for managing UI state by emitting states.
  - **screens/**: The UI screens of the feature.
  - **widgets/**: Reusable widgets specific to the feature.

## shared/
The `shared` directory includes reusable components that can be used across multiple features.

- **data/**: Reusable data models and repositories.
- **handlers/**: Utilities for tasks like networking or storage.
- **widgets/**: Generic, reusable widgets that aren't tied to a single feature.

## app.dart & main.dart
- **app.dart**: The entry point of the app, responsible for initializing services and routes.
- **main.dart**: The starting point for running the Flutter application.

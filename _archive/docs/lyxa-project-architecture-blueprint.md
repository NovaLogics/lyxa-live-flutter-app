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

<br>

#### CONCEPTUAL ARCHITECTURE DIAGRAM

```bash
📂lib/
├──📂src/
│   ├──📂core/     # Core components such as configurations, constants, services, and utilities
│   ├──📂features/ # Individual feature modules (e.g., feature1, feature2)
│   └──📂shared/   # Shared resources like widgets, data handlers, and common logic
│   
└──📄main.dart     # Entry point of the application
```

<br>

#### PROJECT STRUCTURE | HIGH-LEVEL ▼


```plaintext
📂lib/
├──📂src/
│   ├──📂core/
│   │   ├──📂configs/        
│   │   ├──📂constants/
│   │   ├──📂dependency_injection/  
│   │   ├──📂services/  
│   │   ├──📂themes/     
│   │   ├──📂utils/          
│   │   └──📂validations/       
│   │  
│   ├──📂features/
│   │   ├──📂feature1/
│   │   │   ├──📂data/
│   │   │   │   ├──📂models/
│   │   │   │   │   └──📄feature_model.dart
│   │   │   │   └──📂repositories/
│   │   │   │       └──📄feature_repository_impl.dart
│   │   │   │       
│   │   │   ├──📂domain/
│   │   │   │   ├──📂entities/
│   │   │   │   │   └──📄feature_entity.dart
│   │   │   │   ├──📂repositories/
│   │   │   │   │   └──📄feature_repository.dart
│   │   │   │   └──📂usecases/
│   │   │   │       └──📄get_data.dart
│   │   │   │       
│   │   │   └──📂presentation/
│   │   │       ├──📂cubits/
│   │   │       │   ├──📄feature_cubit.dart
│   │   │       │   └──📄feature_state.dart
│   │   │       ├──📂screens/
│   │   │       │   └──📄feature_screen.dart
│   │   │       └──📂widgets/
│   │   │           └──📄feature_widget.dart
│   │   │ 
│   │   └──📂feature2.../
│   │   
│   ├──📂shared/
│   │   ├──📂data/
│   │   ├──📂handlers/
│   │   └──📂widgets/
│   │   
│   └──📄app.dart   
│     
└──📄main.dart
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


---
<br>

# Clean Architecture

Clean Architecture is a design pattern that divides an application into distinct layers, each with well defined responsibilities. It ensures that dependencies always point **inwards**, protecting the core logic from being affected by external frameworks or changes to the UI.

---

## Layers in Clean Architecture

### 1. **Data Layer**
   - **Purpose**: Manages all data operations and interactions with external sources.
   - **Responsibilities**:
     - Fetching data from APIs, databases, or local storage.
     - Converting raw data into usable models for the application.
   - **Examples**:
     - API services, database helpers, and repository implementations.

### 2. **Domain Layer**
   - **Purpose**: Contains the core business logic and rules of the application.
   - **Responsibilities**:
     - Defining **entities** that represent core data models.
     - Implementing **use cases** to encapsulate specific business logic.
     - Providing **abstract repository interfaces** for communication between the Data and Domain layers.
   - **Examples**:
     - `FetchUserData` use case, `UserEntity`, and `UserRepository` interface.

### 3. **Presentation Layer**
   - **Purpose**: Manages the UI and state of the application.
   - **Responsibilities**:
     - Communicating with the Domain Layer through **BLoC** or **Cubit**.
     - Building visual representations of the application using screens and widgets.
   - **Examples**:
     - `UserCubit`, `UserScreen`, and reusable widgets like `CustomButton`.

---

## Communication Between Layers

- **Data → Domain**: Implements repository interfaces from the Domain Layer to fetch or manipulate data.
- **Domain → Presentation**: Provides use cases to the Presentation Layer for accessing business logic.
- **Presentation → Domain**: Triggers use cases through state management mechanisms (e.g., Cubits, BLoC).

Each layer interacts **only** with the one below it, maintaining a unidirectional flow of dependencies.

---

<br>

# State Management: BLoC and Cubit

## **BLoC (Business Logic Component)**

### Overview
BLoC separates **business logic** from the **UI** by using **streams** to manage state transitions. It provides a structured and reactive way to handle application behavior.

### Components:
1. **Events**: Represent user actions or system events (e.g., "Fetch Data").
2. **States**: Represent the app's state at any given time (e.g., "Loading", "Success", "Error").
3. **BLoC**: The mediator that listens for **events**, processes **logic**, and emits **new states**.

### Usage in Lyxa:
- Each feature has its dedicated BLoC.
- The BLoC listens for user actions and emits updated states, enabling dynamic UI updates.

---

## **Cubit**

### Overview
Cubit simplifies state management compared to BLoC by **emitting states directly**, without requiring streams or events.

### How It Works:
- States are updated using methods.
- Cubits reduce boilerplate, making them ideal for features with straightforward state management.

### Usage in Lyxa:
- Features that do not require event-based logic use Cubits.
- **Example**: `ThemeCubit` for toggling between light and dark modes.

---

# Summary

# Lyxa Project Architecture

The Lyxa project uses **Clean Architecture**, along with **BLoC** and **Cubit**, to manage app states effectively. This approach ensures:

- **Clear roles**: Each part of the app focuses on its specific job.
- **Easy testing**: The app is designed so that its parts can be tested separately and reliably.
- **Room to grow**: New features can be added or updated without breaking the rest of the app.
- **Consistency**: A standard structure makes the code easier to work with and helps new developers get started faster.

By following these principles, Lyxa is built to be flexible, reliable, and ready to grow in the future.


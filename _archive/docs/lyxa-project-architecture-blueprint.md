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
│   │   │   │   ├── repositories/
│   │   │   │       ├── feature_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── feature_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── feature_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │       ├── get_data.dart
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
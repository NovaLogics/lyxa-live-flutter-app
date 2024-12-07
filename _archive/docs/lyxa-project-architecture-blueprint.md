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

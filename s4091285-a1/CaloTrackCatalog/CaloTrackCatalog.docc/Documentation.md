# ``s4091285_a1``

## Introduction

Welcome to the documentation for **CaloTrack** 

A nutrition-tracking SwiftUI application that allows users to track their calories, macronutrients and weight progress, search for food items using OpenFoodFacts API, and log meals daily.

This documentation provides an overview of the app’s architecture, its models, views and view models. As well as guidance for maintaining and possibly extending the project.  

![Dashboard Screenshot](Dashboard.png)  
A preview of the main dashboard view in CaloTrack.

---

## Architecture

CaloTrack follows the **MVVM (Model–View–ViewModel)** pattern:  
- **Models** define data structures.  
- **ViewModels** manage app state and business logic.  
- **Views** present data and handle user interactions.  

This ensures the project is modular, testable, and easy to maintain.

---

## Getting Started

1. **Create a Profile**  
   Enter your personal details and nutrition goals in ``FormView``.  

2. **Log Meals**  
   Use ``SearchView`` or ``BarcodeView`` to add foods to your daily log.  

3. **Track Progress**  
   Review your nutrition summary and your weight history in ``DashboardView``.  


## Topics

### Firestore

This app relies upon Google's Firebase and it's Firestore Database to handle data on the cloud.
- ``FirestoreService``

### API

This app utilises OpenFoodFacts as it's Main API to provide the user with access to countless Australian Food Items
- ``OpenFoodFactsAPI``

### Models

Data structs that define food items, user information, and logs.
- ``FoodItem``
- ``UserProfile``
- ``WeightLog``

### View Models

The business logic and state management layer of CaloTrack.
- ``AuthViewModel``
- ``BarcodeViewModel``
- ``DailyLogViewModel``
- ``MacroCardViewModel``
- ``UserProfileViewModel``
- ``WeightViewModel``

### Views

SwiftUI components that make up the CaloTrack user interface.
- ``AllMealsView``
- ``BarcodeView``
- ``CaloTrackApp``
- ``ContentView``
- ``CustomLayoutView``
- ``DashboardView``
- ``FoodDetailView``
- ``FormView``
- ``HistoricalDataView``
- ``MacroCardView``
- ``ManualLogView``
- ``OnboardingView``
- ``PersonalDetailsView``
- ``SearchView``
- ``SettingsView``
- ``SigninView``
- ``WeightInputView``


# CaloTrack – iOS Calorie & Weight Tracker

CaloTrack is an iOS application built with **SwiftUI** that helps users track their daily calorie intake, macronutrients, and weight progress.  
It follows **Apple’s Human Interface Guidelines (HIG)** for a clean, intuitive, and user-friendly experience.  
All data is stored locally on the device using **JSON file persistence** — no internet connection is required for core functionality.

---

## Features
- **Dashboard** – View daily calorie budget, consumed calories, macros, and weight progress at a glance.
- **Meal Logging** – Add foods with calories and macros for breakfast, lunch, dinner, or snacks.
- **Barcode Scanner** *(placeholder)* – Scan product barcodes for quick calorie lookup.
- **Food Search** *(placeholder)* – Search for food items via an external API (e.g., Open Food Facts).
- **Weight Tracking** – Input daily weight and view progress over time.
- **Settings** – Manage preferences *(placeholder for future customisation)*.

---

## App Flow
1. **Dashboard**  
   Displays daily calorie stats and weight information.  
   Quick links to **All Meals** and **Input Weight**.

2. **All Meals**  
   Lists all foods logged for the current day.  
   Allows deletion of meals.

3. **Barcode Scanner** *(planned)*  
   Uses device camera to scan barcodes.  
   Retrieves food data from an external API.

4. **Search Food** *(planned)*  
   Search for food items via API.  
   Add selected food to the meal log.

5. **Manual Food Log**  
   Add foods by entering name, calories, and macros manually.

6. **Weight Input**  
   Input current weight.  
   Stores history for progress tracking.

---

## Data Storage
CaloTrack uses **local JSON files** for persistence, ensuring the app works offline.

**Files:**
- `foods.json` – Stores all logged food items.
- `weights.json` – Stores all weight entries.

**Data Models:**
```swift
struct FoodItem: Identifiable, Codable {
    var id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
}

struct WeightLog: Identifiable, Codable {
    var id: UUID
    var date: Date
    var weight: Double
}

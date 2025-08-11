# CaloTrack – iOS Calorie Tracker

CaloTrack is an iOS application built with **SwiftUI** that helps users track their daily calorie intake, macronutrients, and weight progress.  

---

## Group Details

### Group Members
Binyam Sisay (s4091285)

### GitHub URL
https://github.com/rmit-iPSE-s2-2025/a1-s4091285


## Features
- **Dashboard** – View daily calorie budget, consumed calories, macros, and weight progress at a glance.
- **Meal Logging** – Add foods with calories and macros for breakfast, lunch, dinner, or snacks.
- **Barcode Scanner** *(placeholder)* – Scan product barcodes for quick calorie lookup.
- **Food Search** *(placeholder)* – Search for food items via an external API (e.g., Open Food Facts).
- **Weight Tracking** – Input daily weight and view progress over time.
- **Settings** – Manage preferences *(placeholder for future customisation)*.

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

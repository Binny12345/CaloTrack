//
//  FoodDetailView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 20/8/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let foodItem: FoodItem
    
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMenuType: String = "Breakfast"
    @State private var servingSize: Double = 1.0
    
    let options = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    init(foodItem: FoodItem,
         dailyLogViewModel: DailyLogViewModel,
    ) {
        self.foodItem = foodItem
        self._dailyLogViewModel = ObservedObject(initialValue: dailyLogViewModel)

        // Seed state from passed-in food item
        self._selectedMenuType = State(initialValue: foodItem.mealType)
        self._servingSize = State(initialValue: 1.0)
    }
    
    // Adjust nutrition based on serving size
    var adjustedFoodItem: FoodItem {
        FoodItem(
            id: foodItem.id,
            name: foodItem.name,
            calories: foodItem.calories * servingSize,
            protein: foodItem.protein * servingSize,
            carbs: foodItem.carbs * servingSize,
            fats: foodItem.fats * servingSize,
            mealType: selectedMenuType,
            date: Date()
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(foodItem.name)
                .font(.title)
                .bold()
            
            // Base Info
            Text("\(Int(foodItem.calories)) kcal (per serving)")
                .font(.headline)
            Text("\(Int(foodItem.protein)) g protein • \(Int(foodItem.carbs)) g carbs • \(Int(foodItem.fats)) g fats")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Meal Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Meal Type")
                    .font(.title3)
                Picker("Meal Type", selection: $selectedMenuType) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Serving Size
            VStack(alignment: .leading, spacing: 8) {
                Text("Serving Size: \(servingSize, specifier: "%.1f")x")
                Stepper("Adjust Portion", value: $servingSize, in: 0.5...5, step: 0.5)
            }
            
            // Adjusted Nutrition
            VStack(spacing: 12) {
                Text("Adjusted Nutrition")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    NutritionItem(label: "Calories", value: Int(adjustedFoodItem.calories), unit: "kcal")
                    Spacer()
                    NutritionItem(label: "Protein", value: Int(adjustedFoodItem.protein), unit: "g")
                    Spacer()
                    NutritionItem(label: "Carbs", value: Int(adjustedFoodItem.carbs), unit: "g")
                    Spacer()
                    NutritionItem(label: "Fats", value: Int(adjustedFoodItem.fats), unit: "g")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 12) {
                Button("Add to Log") {
                    dailyLogViewModel.addFoodToLog(foodItem: adjustedFoodItem, mealType: selectedMenuType)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Close") {
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .task(id: foodItem.id) {
            selectedMenuType = foodItem.mealType
            servingSize = 1.0
        }
        .padding()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var showingDetail = true
        @State var selectedFood = FoodItem(
            id: UUID(),
            name: "Banana",
            calories: 80,
            protein: 1,
            carbs: 22,
            fats: 0,
            mealType: "Snack",
            date: Date()
        )
        
        @StateObject var logVM = DailyLogViewModel()
        
        var body: some View {
            FoodDetailView(
                foodItem: selectedFood,
                dailyLogViewModel: logVM
            )
        }
    }
    return PreviewWrapper()
}

// MARK: - Helper View for Nutrition Display
struct NutritionItem: View {
    let label: String
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

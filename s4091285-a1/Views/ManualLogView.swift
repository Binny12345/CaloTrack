//
//  ManualLogView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 6/9/2025.
//

import SwiftUI
import SwiftData

/// Used to let the user manually input their food item
struct ManualLogView: View {
    
    // State and object variables
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @Environment(\.dismiss) private var dismiss // Used for dismissing the view, as it is a sheet
    
    @State private var selectedMenuType: String = "Breakfast"
    @State private var servingSize: Double = 1.0
    @State var foodName: String = ""
    @State var calories: String = ""
    @State var protein: String = ""
    @State var carbs: String = ""
    @State var fats: String = ""
    
    let options = ["Breakfast", "Lunch", "Dinner", "Snack"]
    let foodItem: FoodItem? = nil

    
    // Adjust nutrition based on serving size
    var adjustedFoodItem: FoodItem {
        let cals = Double(calories) ?? 0
        let prot = Double(protein) ?? 0
        let carb = Double(carbs) ?? 0
        let fat = Double(fats) ?? 0
        
        return FoodItem (
            name: foodName.isEmpty ? "Unnamed Food" : foodName,
            calories: cals * servingSize,
            protein: prot * servingSize,
            carbs: carb * servingSize,
            fats: fat * servingSize,
            mealType: selectedMenuType,
            date: Date()
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                TextField("Food Item Name", text: $foodName)
                    .font(.title)
                    .bold()
                
                // Base Info
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter Calories", text: $calories)
                        .keyboardType(.decimalPad)

                    TextField("Enter Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)

                    TextField("Enter Carbs (g)", text: $carbs)
                        .keyboardType(.decimalPad)

                    TextField("Enter Fats (g)", text: $fats)
                        .keyboardType(.decimalPad)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
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
                    
                    // Passes Data into a custom struct
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
                
                // Buttons to add or leave
                VStack(spacing: 12) {
                    Button("Add to Log") {
                        Task {
                            await dailyLogViewModel.addFoodToLog(foodItem: adjustedFoodItem, mealType: selectedMenuType)
                            dismiss()
                        }
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
            .scrollDismissesKeyboard(.interactively) // Lets user exit keyboard view
        }
        .task {
            if let foodItem = foodItem {
                // Sets FoodItem's mealType and serving size
                selectedMenuType = foodItem.mealType
                servingSize = 1.0
            }
        }
        .padding()
    }
}


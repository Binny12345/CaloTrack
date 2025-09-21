//
//  AllMealsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// AllMealsView displays all of the user's logged meals for the day
struct AllMealsView: View {
    
    // Observed objects in order to use it's data
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    /// Groups meals by their mealType
    var groupedMeals: [String: [FoodItem]] {
        Dictionary(grouping: dailyLogViewModel.dailyLogs, by: { $0.mealType })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title
                Text("All Meals")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Meal Sections
                ForEach(["Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { mealType in
                    if let foods = groupedMeals[mealType], !foods.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(mealType)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            FoodItemCard(dailyLogViewModel: dailyLogViewModel, foods: foods)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

/// FoodItemCard displays each individual food item
struct FoodItemCard: View {

    // Observed objects in order to use it's data
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    let foods: [FoodItem]
    
    var body: some View {
        VStack(spacing: 8) {
            // Iterates through each food item in foods and displays in formatted appearance
            ForEach(foods, id: \.id) { food in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(food.name)
                            .font(.body)
                            .fontWeight(.medium)
                        Text("\(Int(food.calories)) kcal • \(Int(food.protein))g P • \(Int(food.carbs))g C • \(Int(food.fats))g F")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    // Delete button
                    Button {
                        dailyLogViewModel.removeLog(withId: food.id)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .frame(width: 24, height: 24)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 1)
            }
        }
        .padding(.horizontal)
    }
}


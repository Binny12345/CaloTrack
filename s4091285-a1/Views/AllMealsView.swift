//
//  AllMealsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// AllMealsView needed to display all of the user's logged meals for the day
struct AllMealsView: View {
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    /// Groups meals by their mealType
    var groupedMeals: [String: [DailyLog]] {
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

/// FoodItemCard to display each individual food item
struct FoodItemCard: View {
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    let foods: [DailyLog]
    
    var body: some View {
        VStack(spacing: 8) {
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

#Preview {
//    NavigationStack {
//        AllMealsView(dailyLogViewModel: DailyLogViewModel())
//    }
}

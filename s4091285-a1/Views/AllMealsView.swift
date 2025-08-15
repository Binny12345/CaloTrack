//
//  AllMealsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct AllMealsView: View {
    let sampleFoods: [FoodItem] = DataManager.loadFoodData()
    
    var groupedMeals: [String: [FoodItem]] {
        Dictionary(grouping: sampleFoods, by: { $0.mealType })
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
                            
                            FoodItemCard(foods: foods)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("All Meals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FoodItemCard: View {
    let foods: [FoodItem]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(foods, id: \.id) { food in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(food.name)
                            .font(.body)
                            .fontWeight(.medium)
                        Text("\(Int(food.calories)) kcal • \(Int(food.protein))g Protein")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .frame(width: 24, height: 24)
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
    NavigationStack {
        AllMealsView()
    }
}

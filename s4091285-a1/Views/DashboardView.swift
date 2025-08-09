//
//  DashboardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct DashboardView: View {
    // Dummy sample data
    let sampleFoods: [FoodItem] = [
        FoodItem(name: "Grilled Chicken", calories: 250, protein: 30, carbs: 0, fats: 5, mealType: "Lunch", date: Date()),
        FoodItem(name: "Oatmeal", calories: 150, protein: 5, carbs: 27, fats: 3, mealType: "Breakfast", date: Date()),
        FoodItem(name: "Apple", calories: 80, protein: 0, carbs: 22, fats: 0, mealType: "Snack", date: Date())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Calorie summary
                Text("Calories Today: \(sampleFoods.reduce(0) { $0 + $1.calories }, specifier: "%.0f") kcal")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Macro breakdown
                HStack {
                    VStack {
                        Text("Protein")
                        Text("\(sampleFoods.reduce(0) { $0 + $1.protein }, specifier: "%.0f")g")
                            .fontWeight(.bold)
                    }
                    Spacer()
                    VStack {
                        Text("Carbs")
                        Text("\(sampleFoods.reduce(0) { $0 + $1.carbs }, specifier: "%.0f")g")
                            .fontWeight(.bold)
                    }
                    Spacer()
                    VStack {
                        Text("Fats")
                        Text("\(sampleFoods.reduce(0) { $0 + $1.fats }, specifier: "%.0f")g")
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

// Preview with dummy data
#Preview {
    DashboardView()
}

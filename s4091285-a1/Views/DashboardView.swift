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
    
    var totalCalories: Int {
        Int(sampleFoods.reduce(0) { $0 + $1.calories })
    }
    
    var totalProtein: Int {
        Int(sampleFoods.reduce(0) { $0 + $1.protein })
    }
    
    var totalCarbs: Int {
        Int(sampleFoods.reduce(0) { $0 + $1.carbs })
    }
    
    var totalFats: Int {
        Int(sampleFoods.reduce(0) { $0 + $1.fats })
    }
    
    var body: some View {
        ScrollView {
            Text("Dashboard")
                .multilineTextAlignment(.leading)
                .font(.title)
                .bold()
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Calorie Summary
                VStack(alignment: .leading, spacing: 10) {
                    Text("Calories Today")
                        .font(.headline)
                    HStack {
                        Text("\(totalCalories) kcal")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                    HStack {
                        Text("Remaining: \(2000 - totalCalories) kcal")
                            .foregroundStyle(.gray)
                    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // MARK: - Macros
                VStack(alignment: .leading, spacing: 10) {
                    Text("Macronutrients")
                        .font(.headline)
                    
                    HStack {
                        MacroItem(label: "Protein", value: totalProtein, unit: "g")
                        Spacer()
                        MacroItem(label: "Carbs", value: totalCarbs, unit: "g")
                        Spacer()
                        MacroItem(label: "Fats", value: totalFats, unit: "g")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // MARK: - Weight Stats Placeholder
                VStack(alignment: .leading) {
                    Text("Weight Stats")
                        .foregroundColor(.gray)
                        .padding(.top)
                    // Add real weight graph or stats here
                    Text("No data yet.")
                }
                .frame(width: 340, height: 280)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Dashboard")
      }
    }



// MARK: - Macro Subview
struct MacroItem: View {
    let label: String
    let value: Int
    let unit: String

    var body: some View {
        VStack {
            Text(label)
                .font(.subheadline)
            Text("\(value)\(unit)")
                .fontWeight(.bold)
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}

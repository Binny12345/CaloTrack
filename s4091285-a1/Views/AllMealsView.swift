//
//  AllMealsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct AllMealsView: View {
    var body: some View {
        let sampleFoods: [FoodItem] = DataManager.loadFoodData()
        
        VStack(alignment: .leading) {
            Text("All Meals")
                .font(.title)
                .bold()
        }
        .padding()
        
            VStack {
                Text("Breakfast")
                    .font(.title2)
                    .bold()
                ForEach(sampleFoods) { food in
                    if food.mealType == "Breakfast" {
                        Text(food.name)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        
            VStack {
                Text("Lunch")
                    .font(.title2)
                    .bold()
                ForEach(sampleFoods) { food in
                    if food.mealType == "Lunch" {
                        Text(food.name)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        
            VStack {
                Text("Dinner")
                    .font(.title2)
                    .bold()
                ForEach(sampleFoods) { food in
                    if food.mealType == "Dinner" {
                        Text(food.name)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        
            VStack {
                Text("Snacks")
                    .font(.title2)
                    .bold()
                ForEach(sampleFoods) { food in
                    if food.mealType == "Snack" {
                        Text(food.name)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        }
    }


#Preview {
    AllMealsView()
}

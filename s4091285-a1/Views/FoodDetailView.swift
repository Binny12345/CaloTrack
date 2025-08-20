//
//  FoodDetailView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 20/8/2025.
//

import SwiftUI

struct FoodDetailView: View {
    @Binding var showingFoodDetail: Bool
    @Binding var foodItem: FoodItem?
    
    @State private var selectedMenuType: String = "Breakfast"
    @State private var servingSize: String = ""
    
    let options = ["Breakfast", "Lunch", "Dinner", "Snacks"]
    
    var body: some View {
        if let food = foodItem {
            VStack(alignment: .leading, spacing: 12) {
                Text(food.name)
                    .font(.title)
                    .bold()
                
                Text("\(Int(food.calories)) kcal")
                    .font(.headline)
                
                Text("\(Int(food.protein)) g protein • \(Int(food.carbs)) g carbs • \(Int(food.fats)) g fats")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text("Select Meal Type:")
                .font(.title3)
                .padding()
            VStack {
                Picker("Select Meal Type:", selection: $selectedMenuType) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                
                
                TextField("Serving Size", text: $servingSize)
                    .keyboardType(.decimalPad)
                    .onChange(of: servingSize) { oldValue, newValue in
                        let filtered = newValue.filter {
                            "0123456789".contains($0)
                        }
                        if filtered != newValue {
                            servingSize = filtered
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
            }
                
                
                
            VStack {
                
                Button("Add to Log") {
                    showingFoodDetail = false
                    // TODO: Implement adding food item into daily log
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green)
                .foregroundStyle(.white)
                .cornerRadius(10)
                
                
                Button("Close") {
                    showingFoodDetail = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        } else {
            Text("No food selected")
        }
    }
}

#Preview {
    // Contains Example food data
    // in order to create preview
    let mockFood = FoodItem(
        id: UUID(),
        name: "Banana",
        calories: 80,
        protein: 0,
        carbs: 22,
        fats: 0,
        mealType: "Snack",
        date: Date()
    )
    
    // Use State to simulate bindings
    @State var showingDetail = true
    @State var selectedFood: FoodItem? = mockFood
    
    FoodDetailView(
        showingFoodDetail: $showingDetail,
        foodItem: $selectedFood
    )
}

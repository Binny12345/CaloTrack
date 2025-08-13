//
//  DashboardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct DashboardView: View {
    // Dummy sample data
    let sampleFoods: [FoodItem] = DataManager.loadFoodData()
    
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
        let progress = Double(totalCalories) / 2000.0
        
        ScrollView {
            Text("Dashboard")
                .multilineTextAlignment(.leading)
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 20) {
            
                // MARK: - Calorie Today/Remaining
                HStack(alignment: .center, spacing: 20) {
                    
                    // Progress Ring
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 18)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(totalCalories)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 130, height: 130)
                    .padding(.leading, 4)
                    
                    Spacer()
                    
                    // Text Info
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Total \n2000 kcal")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Consumed\n\(totalCalories) kcal")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                        NavigationLink(destination: AllMealsView()) {
                            Text("All Meals")
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                                .cornerRadius(3)
                        
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
                
                // MARK: - Macros
                VStack(alignment: .leading, spacing: 12) {
                    Text("Macronutrients")
                        .font(.headline)
                        .bold()

                    VStack(alignment: .leading) {
                        Text("Protein: \(totalProtein)g")
                        ProgressView(value: Double(totalProtein), total: 150)
                            .tint(.green)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Carbs: \(totalCarbs)g")
                        ProgressView(value: Double(totalCarbs), total: 100)
                            .tint(.green)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Fats: \(totalFats)g")
                        ProgressView(value: Double(totalFats), total: 100)
                            .tint(.green)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
                // MARK: - Weight Stats Placeholder
                VStack(alignment: .leading) {
                    Text("Weight Stats")
                        .foregroundColor(.gray)
                        .padding(.top)
                    // Add real weight graph or stats here
                    
                }
                .frame(width: 340, height: 280)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
            .padding()
            Spacer()
        }
        
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

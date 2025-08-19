//
//  DashboardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI
import Charts

// MARK: - Custom Welcome Layout
struct WelcomeLayout: Layout {
    var spacing: CGFloat = 12
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxWidth = proposal.width ?? 0
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        // Calculate the total width needed and maximum height
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            totalWidth += size.width
            maxHeight = max(maxHeight, size.height)
            
            // Add spacing between elements (but not after the last one)
            if index < subviews.count - 1 {
                totalWidth += spacing
            }
        }
        
        return CGSize(
            width: min(totalWidth, maxWidth),
            height: maxHeight
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        var currentX = bounds.minX
        let centerY = bounds.midY
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            // Center each subview vertically
            let yPosition = centerY - (size.height / 2)
            
            subview.place(
                at: CGPoint(x: currentX, y: yPosition),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
        }
    }
}



struct DashboardView: View {
    // Dummy sample data
    let sampleFoods: [FoodItem] = DataManager.loadFoodData()
    @ObservedObject var weightViewModel: WeightViewModel
    
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
    var proteinGoal = 150
    var fatGoal = 100
    var carbsGoal = 300
    var weightGoal = 50
    let userName = "Binny"
    
    var body: some View {
        let progress = Double(totalCalories) / 2000.0
        
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Custom Welcome Header using Layout Protocol
                WelcomeLayout(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    Text("Welcome,  \(userName)!")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: - Dashboard Title
                HStack {
                    Text("Dashboard")
                        .multilineTextAlignment(.leading)
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
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
                                .frame(width: 80, height: 50)
                                .fontWeight(.semibold)
                                .background(.green)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                            
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
                            Text("Protein: \(totalProtein)g / \(proteinGoal)g")
                            ProgressView(value: Double(totalProtein), total: Double(proteinGoal))
                                .tint(.green)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Carbs: \(totalCarbs)g / \(carbsGoal)g")
                            ProgressView(value: Double(totalCarbs), total: Double(carbsGoal))
                                .tint(.green)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Fats: \(totalFats)g / \(fatGoal)g")
                            ProgressView(value: Double(totalFats), total: Double(fatGoal))
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
                            .font(.title3)
                            .font(.headline)
                            .bold()
                        
                        Text("Goal: \(weightGoal)kg")
                            .foregroundStyle(.secondary)
                            .padding(.bottom)
                        
                        let weightData: [WeightLog] = weightViewModel.logs.map { log in
                            WeightLog(weight: Double(log.weight), date: log.date)
                        }
                        
                        HStack {
                            Chart(weightData) {
                                LineMark(
                                    x: .value("Date", $0.date),
                                    y: .value("Weight", $0.weight)
                                )
                                .foregroundStyle(.gray)
                                
                                PointMark(
                                    x: .value("Date", $0.date),
                                    y: .value("Weight", $0.weight)
                                )
                                .symbol(.circle)
                                .symbolSize(30)
                                .foregroundStyle(.green)
                            }
                            .frame(height: 200)
                        }
                        
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
        DashboardView(weightViewModel: WeightViewModel())
    }
    
    

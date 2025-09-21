//
//  DashboardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI
import Charts
import SwiftData

// MARK: - Custom Welcome Layout
/// The main home screen showing calories, macros, weight progress, and navigation into other sections. Acts as the hub for data visualization.
struct DashboardView: View {
    // Passed in objects from MainTabView (MVVM Separation)
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    @StateObject private var macroCardVM = MacroCardViewModel() // State Object to manage MacroCard Gesture state
    
    // Computed properties to sum up today’s logs into totals
    var totalCalories: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { sum, log in
            sum + (log.calories)
        })
    }
    
    var totalProtein: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { sum, log in
            sum + (log.protein)
        })
    }
    
    var totalCarbs: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { sum, log in
            sum + (log.carbs)
        })
    }
    
    var totalFats: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { sum, log in
            sum + (log.fats)
        })
    }
    
    
    var body: some View {
        
        // Variabes created for using data from userProfileViewModel
        let calories = userProfileViewModel.currentUser?.calorieBudget ?? 1800
        let progress = Double(totalCalories) / Double(calories)
        let proteinGoal = userProfileViewModel.currentUser?.proteinGoal ?? 100
        let fatGoal = userProfileViewModel.currentUser?.fatGoal ?? 100
        let carbsGoal = userProfileViewModel.currentUser?.carbGoal ?? 100
        let weightGoal = userProfileViewModel.currentUser?.weightGoal ?? 50
        let userName = userProfileViewModel.currentUser?.name ?? "User"
        
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Custom Layout Welcome Header using Layout Protocol
                CustomLayoutView(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    Text("Welcome \(userName)!")
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
                    
                    // Calorie Summary with progress ring and text
                    HStack(alignment: .center, spacing: 24) {
                        
                        // Progress Ring
                        ZStack {
                            // Changes Color depending on total calories consumed
                            let ringColor = progress > 1.0 ? Color.red : Color.green
                            
                            // Grey Inner Circle
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 18)
                            
                            // Green/Red Outter Circle
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(ringColor, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 2) {
                                Text("\(totalCalories)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Remaining")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 120, height: 120)
                        .padding(.leading, 4)
                        
                        // Text Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Budget")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Text("\(calories) kcal")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        
                        // Remaining Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Left")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            if totalCalories > calories {
                                Text("\(calories - totalCalories) kcal")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            } else {
                                Text("\(calories - totalCalories) kcal")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    // Navigation button -> AllMealsView
                    NavigationLink(destination: AllMealsView(dailyLogViewModel: dailyLogViewModel)) {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("All Meals")
                                .frame(width: 100, height: 30)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .background(.green)
                                .foregroundStyle(.white)
                                .cornerRadius(5)
                        }
                        .frame(width: 100, height: 40)
                        .background(.green)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
                
                // MARK: - Macros
                // Macros (delegates to MacroCardView)
                VStack(alignment: .center, spacing: 12) {
                    Text("Macronutrients")
                        .font(.headline)
                        .bold()
                    
                    HStack(alignment: .firstTextBaseline) {
                        MacroCardView(viewModel: macroCardVM)
                            .onAppear {
                                macroCardVM.update(
                                    protein: totalProtein,
                                    carbs: totalCarbs,
                                    fats: totalFats,
                                    proteinGoal: proteinGoal,
                                    carbsGoal: carbsGoal,
                                    fatsGoal: fatGoal
                                )
                            }
                            .onChange(of: dailyLogViewModel.todaysLogs) { _, _ in
                                macroCardVM.update(
                                    protein: totalProtein,
                                    carbs: totalCarbs,
                                    fats: totalFats,
                                    proteinGoal: proteinGoal,
                                    carbsGoal: carbsGoal,
                                    fatsGoal: fatGoal
                                )
                            }
                    }

                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
                // MARK: - Weight Stats Placeholder
                VStack(alignment: .leading) {
                    Text("Weight Stats")
                        .font(.headline)
                        .bold()
                    Text("Goal: \(weightGoal)kg")
                        .foregroundStyle(.secondary)
                    
                    // Chart that maps the weight lops inputted from WeightVM
                    // Creates points of each weight log and lines connecting them
                    Chart(weightViewModel.weightLogs) { log in
                        LineMark(
                            x: .value("Date", log.date),
                            y: .value("Weight", log.weight)
                        )
                        PointMark(
                            x: .value("Date", log.date),
                            y: .value("Weight", log.weight)
                        )
                        .symbol(.circle)
                        .symbolSize(30)
                        .foregroundStyle(.green)
                    }
                    .frame(height: 200)
                }
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

    

//
//  DashboardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI
import Charts

// MARK: - Custom Welcome Layout

/// DashboardView to display the user's initial Data and what they have consumed
struct DashboardView: View {

    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    var totalCalories: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { $0 + $1.calories })
    }
    
    var totalProtein: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { $0 + $1.protein })
    }
    
    var totalCarbs: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { $0 + $1.carbs })
    }
    
    var totalFats: Int {
        Int(dailyLogViewModel.todaysLogs.reduce(0) { $0 + $1.fats })
    }
    var proteinGoal = 150
    var fatGoal = 100
    var carbsGoal = 300
    var weightGoal = 50
    let userName = "User"
    
    var body: some View {
        let progress = Double(totalCalories) / 2000.0
        
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
                        
                        Spacer()
                        
                        // Text Info
                        VStack(alignment: .leading, spacing: 4) {
                             Text("Daily Goal")
                                 .font(.subheadline)
                                 .fontWeight(.medium)
                                 .foregroundColor(.secondary)
                             Text("2000 kcal")
                                 .font(.title3)
                                 .fontWeight(.bold)
                         }
                         
                         // Remaining Section
                         VStack(alignment: .leading, spacing: 4) {
                             Text("Remaining")
                                 .font(.subheadline)
                                 .fontWeight(.medium)
                                 .foregroundColor(.secondary)
                             if totalCalories > 2000 {
                                 Text("\(2000 - totalCalories) kcal")
                                     .font(.title3)
                                     .fontWeight(.bold)
                                     .foregroundColor(.red)
                             } else {
                                 Text("\(2000 - totalCalories) kcal")
                                     .font(.title3)
                                     .fontWeight(.bold)
                                     .foregroundColor(.green)
                             }
                         }
                     }
                        
                    NavigationLink(destination: AllMealsView(dailyLogViewModel: dailyLogViewModel)) {
                            VStack(spacing: 4) {
                                Text("All Meals")
                                    .frame(width: 80, height: 50)
                                    .fontWeight(.semibold)
                                    .background(.green)
                                    .foregroundStyle(.white)
                                    .cornerRadius(8)
                            }
                            .frame(width: 100, height: 60)
                            .background(.green)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(20)
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

    
    // MARK: - Preview
    #Preview {
        DashboardView(weightViewModel: WeightViewModel(), dailyLogViewModel: DailyLogViewModel())
    }
    
    

//
//  HistoricalDataView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 12/9/2025.
//

import SwiftUI
import SwiftData

/// Used to provide the user a page to view all of their past food logs
struct HistoricalDataView: View {
    
    // Takes in the observed object to access all the dailylogs
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    // Variable to group logs based on days
    private var groupedLogs: [(date: Date, logs: [FoodItem])] {
        let grouped = Dictionary(grouping: dailyLogViewModel.dailyLogs) { log in
            Calendar.current.startOfDay(for: log.date)
        }
        return grouped
            .map { (date: $0.key, logs: $0.value) }
            .sorted { $0.date > $1.date }
    }
    var body: some View {
        NavigationView {
            List {
                // Outputs them by each day, and outputs each food log in a formatted display
                ForEach(groupedLogs, id: \.date) { group in
                    Section(header: Text(group.date, style: .date)) {
                        ForEach(group.logs) { log in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(log.name)
                                        .font(.headline)
                                    Text(log.mealType)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(Int(log.calories)) kcal")
                                        .bold()
                                    HStack {
                                        Text("P: \(Int(log.protein))g")
                                        Text("C: \(Int(log.carbs))g")
                                        Text("F: \(Int(log.fats))g")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Historical Logs")
        }
        // Grabs all the logs as soon as page renders
        .onAppear {
            dailyLogViewModel.fetchAllLogsDescending()
        }
    }
}

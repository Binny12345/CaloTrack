//
//  HistoricalDataView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 12/9/2025.
//
import SwiftUI

/// Displays all historical food logs grouped by day
struct HistoricalDataView: View {
    
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    /// Groups logs by day and sorts descending
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
                // Groups logs by day
                ForEach(groupedLogs, id: \.date) { group in
                    Section(header: Text(group.date, style: .date)) {
                        // For Each day, display all logs
                        ForEach(group.logs) { log in
                            DataCardView(log: log)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Historical Logs")
            .onAppear {
                // Fetch all logs from Firestore when view appears
                Task {
                    await dailyLogViewModel.fetchAllLogsDescending()
                }
            }
        }
    }
}

/// Helper struct to format and display a single FoodItem
struct DataCardView: View {
    let log: FoodItem // Passed in fooditem
    
    var body: some View {
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
    }
}

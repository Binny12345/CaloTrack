//
//  HistoricalDataView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 12/9/2025.
//

import SwiftUI
import SwiftData

struct HistoricalDataView: View {
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    private var groupedLogs: [(date: Date, logs: [DailyLog])] {
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
        .onAppear {
            dailyLogViewModel.fetchAllLogsDescending()
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: DailyLog.self)
    let vm = DailyLogViewModel(context: container.mainContext)
    
    vm.dailyLogs = [
        DailyLog(name: "Chicken Breast", calories: 220, protein: 40, carbs: 0, fats: 5, mealType: "Lunch", date: Date()),
                DailyLog(name: "Oatmeal", calories: 150, protein: 5, carbs: 27, fats: 3, mealType: "Breakfast", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
            ]
            
            return HistoricalDataView(dailyLogViewModel: vm)
        }

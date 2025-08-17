//
//  WeightViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

class WeightViewModel: ObservableObject {
    @Published var logs: [WeightLog] = []
    
    func addLog(weight: Double, date: Date, unit: String) {
        let newLog = WeightLog(weight: weight, date: date)
        print("new log: \(newLog)")
        logs.append(newLog)
        print("logs: \(logs)")
    }
    
    func removeLog(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
    }
}

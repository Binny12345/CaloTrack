//
//  WeightInputView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// WeightInputView for the user to input their weight for the day
struct WeightInputView: View {
    @State private var weight: String = ""
    @State private var unit: String = "kg"   // default to kg
    @State private var date: Date = Date()
    @State private var showConfirmation: Bool = false
    @ObservedObject var weightViewModel: WeightViewModel
    
    var body: some View {
        NavigationStack {
            Text("Weight")
                .multilineTextAlignment(.leading)
                .font(.title)
                .bold()
                .padding()
            
            Form {
                Section {
                    HStack {
                        TextField("Weight", text: $weight)
                            .keyboardType(.decimalPad)
                            .onChange(of: weight) { oldValue, newValue in
                                let filtered = newValue.filter {
                                    "0123456789".contains($0)
                                }
                                if filtered != newValue {
                                    weight = filtered
                                }
                            }
                    }
                    
                    DatePicker("Select Day",
                               selection: $date,
                               in: ...Date(),
                               displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    let addButton = Text("Add")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(8)

                    Button(action: {
                        saveWeight()
                    }) {
                        addButton
                    }
                    .disabled(weight.isEmpty)
                }
                
                Section(header: Text("Saved Weights")) {
                    let sortedItems = weightViewModel.weightLogs.sorted{ $0.date > $1.date }
                    
                    ForEach(sortedItems) { log in
                        HStack {
                            Text("\(log.weight, specifier: "%.1f") kg")
                            Spacer()
                            Text(log.date, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                    //.onDelete(perform: weightViewModel.removeLog(weightLogs.self))
                }
            }
            .padding(20)
            .cornerRadius(12)
            .shadow(radius: 1)
            .alert("Weight Has Been Saved!", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private func saveWeight() {
        weightViewModel.addLog(weight: Double(weight) ?? 0, date: date)
        weight = ""
        showConfirmation = true
    }
}

#Preview {
//    WeightInputView(weightViewModel: WeightViewModel())
}

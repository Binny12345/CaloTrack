//
//  WeightInputView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct WeightInputView: View {
    @State private var weight: String = ""
    @State private var unit: String = ""
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
                    }
                    DatePicker("Select Day",
                               selection: $date,
                               in: ...Date(),
                               displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    Button(action: saveWeight) {
                        Text("Add")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .disabled(weight.isEmpty)
                }
                
                Section(header: Text("Saved Weights")) {
                    ForEach(weightViewModel.logs) { log in
                        HStack {
                            Text("\(log.weight, specifier: "%.1f") kg")
                            Spacer()
                            Text(log.date, style: .date)
                                .foregroundStyle(.white)
                                .bold(true)
                            
                        }
                    }
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
        weightViewModel.addLog(weight: Double(weight) ?? 0, date: date, unit: "")
        weight = ""
        showConfirmation = true
    }
}

#Preview {
    WeightInputView(weightViewModel: WeightViewModel())
}

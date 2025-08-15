//
//  WeightInputView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct WeightInputView: View {
    @State private var weight: String = ""
    @State private var selectedUnit: String = "kg"
    @State private var selectedDate = Date()
    @State private var showConfirmation: Bool = false
    
    let units = ["kg", "lbs"]
    
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
                        
                        Picker("", selection: $selectedUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }
                    DatePicker("Select Day",
                               selection: $selectedDate,
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
                
                Section {
                }
            }
            .padding(20)
            .cornerRadius(12)
            .shadow(radius: 1)
            .alert("Weight Saved!", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    private func saveWeight() {
        //TODO: Make data persistent
    }
}

#Preview {
    WeightInputView()
}

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
    @State private var showConfirmation: Bool = false
    
    let units = ["kg", "lbs"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Your Weight")) {
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
                }
                
                Section {
                    Button(action: saveWeight) {
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(weight.isEmpty)
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 1)
            .navigationTitle("Weight")
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

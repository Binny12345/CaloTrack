//
//  WeightInputView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI
import SwiftData
import FirebaseAuth

/// WeightInputView for the user to input their weight for the day
struct WeightInputView: View {
    
    // State variables
    @State private var weight: String = ""
    @State private var unit: String = "kg"   // default to kg
    @State private var date: Date = Date()
    @State private var showConfirmation: Bool = false
    @State private var showDuplicateAlert = false
    
    @ObservedObject var weightViewModel: WeightViewModel
    let uid: String
    
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
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: weight) { oldValue, newValue in
                                // Filters the input
                                let filtered = newValue.filter {
                                    "0123456789".contains($0)
                                }
                                if filtered != newValue {
                                    weight = filtered
                                }
                            }
                    }
                    // Date picker, can't go past current day
                    DatePicker("Select Day",
                               selection: $date,
                               in: ...Date(),
                               displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    
                    // Calls saveWeight( ) when button is pressed
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
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)
                
                // Saved Weights
                Section(header: Text("Saved Weights")) {
                    SavedWeights(uid: Auth.auth().currentUser?.uid ?? "")
                }
            }
            // Confirmation Alert/Duplicate Log Alert
            .alert("Weight Has Been Saved!", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            }
            .alert("Duplicate Weight Log", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    /// Used to save the weight into the Database
    private func saveWeight() {
        print("DEBUG: UID: \(uid)")
        let msg = weightViewModel.addWeightLog(weight: Double(weight) ?? 0, date: date, uid: uid)
        
        if msg != "" {
            // Duplicate case
            showDuplicateAlert = true
            showConfirmation = false
        } else {
            // Success case
            weight = ""
            showConfirmation = true
        }
    }
}

struct SavedWeights: View {
    @Query private var userWeightLogs: [WeightLog]

    init(uid: String) {
        _userWeightLogs = Query(
            filter: #Predicate<WeightLog> { log in
                log.userId == uid
            },
            sort: \.date,
            order: .forward
        )
    }
    var body: some View {
        let sortedItems = userWeightLogs.sorted{ $0.date > $1.date }
        
        ForEach(sortedItems) { log in
            HStack {
                Text("\(log.weight, specifier: "%.1f") kg")
                Spacer()
                Text(log.date, style: .date)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//
//  FormView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/9/2025.
//

import SwiftUI
import FirebaseFirestore

/// Collects user input at registration (name, age, gender, macros, goals).
struct FormView: View {
    // State variables of the user's inputted data
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var gender: String = "Male"
    @State private var proteinGoal: String = ""
    @State private var carbGoal: String = ""
    @State private var fatGoal: String = ""
    @State private var weightGoal: String = ""
    @State private var calorieBudget: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMsg: String = ""
    
    // Observed Objects
    @ObservedObject var auth: AuthViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    private let firestoreService = FirestoreService()
    
    let genders = ["Male", "Female"]
    
    
    // Form
    var body: some View {
        VStack {
            Text("Enter your Details Below")
                .font(.title2)
                .bold()
                .padding(.top, 25)
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    
                    
                    Picker("Sex", selection: $gender) {
                        ForEach(genders, id: \.self) { option in
                            Text(option)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Body Stats") {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.numberPad)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                }
                
                Section("Nutrition Goals") {
                    TextField("Calorie Budget", text: $calorieBudget)
                        .keyboardType(.numberPad)
                    TextField("Protein Goal (g)", text: $proteinGoal)
                        .keyboardType(.numberPad)
                    TextField("Carb Goal (g)", text: $carbGoal)
                        .keyboardType(.numberPad)
                    TextField("Fat Goal (g)", text: $fatGoal)
                        .keyboardType(.numberPad)
                }
                
                Section("Weight Goal") {
                    List {
                        TextField("Enter Your Weight Goal (g)", text: $weightGoal)
                            .keyboardType(.numberPad)
                    }
                }
            } // For when the user wants to exit the keyboard
            .onTapGesture {
                UIApplication.shared.endEditingMode()
            }
            
            // Provides the user with a recommended Budget based on already inputted information
            Text("Recommended Budget Based On Your Stats: \n\(recommendedBudget(age, weight, height, gender))kcal")
                .frame(alignment: .center)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 18)
            
            // Submit Button
            Button("Submit") {
                Task { await handleSubmit() }
            }
            .frame(width: 300, height: 50)
            .background(.green)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .padding()
            .alert("Alert", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMsg)
            }
        }
    }
    
    /// Helper Function to handle validating and passing the data to saveProfile( )
    private func handleSubmit() async {
        errorMsg = inputValidation(
            name, age, weight, height, gender, calorieBudget,
            recommendedBudget: recommendedBudget(age, weight, height, gender),
            proteinGoal, carbGoal, fatGoal
        )
        
        guard errorMsg.hasSuffix("Successfully Submitted") else {
            showAlert.toggle()
            return
        }
        
        // Convert to typed model
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height),
              let calorieInt = Int(calorieBudget),
              let proteinInt = Int(proteinGoal),
              let carbInt = Int(carbGoal),
              let fatInt = Int(fatGoal),
              let weightGoalInt = Int(weightGoal) else {
            errorMsg = "Invalid number format in one or more fields."
            showAlert.toggle()
            return
        }
        
        let profile = UserProfile(
            name: name,
            age: ageInt,
            gender: gender,
            weight: weightDouble,
            height: heightDouble,
            calorieBudget: calorieInt,
            proteinGoal: proteinInt,
            carbGoal: carbInt,
            fatGoal: fatInt,
            weightGoal: weightGoalInt
        )
        do {
            try await userProfileViewModel.saveProfile(
                name: profile.name,
                age: String(profile.age),
                gender: profile.gender,
                weight: String(profile.weight),
                height: String(profile.height),
                calorieBudget: String(profile.calorieBudget),
                proteinGoal: String(profile.proteinGoal),
                carbGoal: String(profile.carbGoal),
                fatGoal: String(profile.fatGoal),
                weightGoal: String(profile.weightGoal)
            )
            userProfileViewModel.isRegistered = true
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    
    
    /// Needed to calculate the recommended calorie budget according to the user's details
    /// - Parameter age: Age that user inputted
    /// - Parameter weight: Weight that user inputted
    /// - Parameter height: Height that user inputted
    /// - Parameter gender: Gender that user inputted
    /// - Returns: Formula for either if the user is male or female
    func recommendedBudget(_ age: String, _ weight: String, _ height: String, _ gender: String) -> Int {
        let age = (Int(age) ?? 0) * 5
        let weight = (Double(weight) ?? 0) * 6.25
        let height = (Int(height) ?? 0) * 10
        
        // Base formula
        var formula = Int(weight) + height - age
        
        // Provide different Calculations depending on gender
        if gender == "Male" {
            formula += 5
        } else if gender == "Female" {
            formula -= 161
        }
        return formula
    }
    
    /// Needed to validate all the input before being submitted
    /// - Parameter name: User's name
    /// - Parameter age: Age that user inputted
    /// - Parameter weight: Weight that user inputted
    /// - Parameter height: Height that user inputted
    /// - Parameter gender: Gender that user inputted
    /// - Parameter calorieBudget: Budget that user inputted
    /// - Parameter recommendedBudget: The recommended budget provided by the recommendedBudget( ) formula
    /// - Parameter proteinGoal: Protein goal that the user inputted
    /// - Parameter carbGoal: Carb goal that the user inputted
    /// - Parameter fatGoal: Fat goal that the user inputted
    /// - Returns: Either error message or "Successfully Submitted"
    func inputValidation(
        _ name: String,
        _ age: String,
        _ weight: String,
        _ height: String,
        _ gender: String,
        _ calorieBudget: String,
        recommendedBudget: Int,
        _ proteinGoal: String,
        _ carbGoal: String,
        _ fatGoal: String
    ) -> String {
        // Variables set from parameters
        var errorMsg: String = ""
        let protein = Int(proteinGoal) ?? 0
        let carbs = Int(carbGoal) ?? 0
        let fats = Int(fatGoal) ?? 0
        let totalMacroCalories = (protein * 4) + (carbs * 4) + (fats * 9)
        
        
        // Personal Info Validation
        if name.wholeMatch(of: #/^[A-Za-z ]{2,30}$/#) == nil {
            errorMsg = "Name Must be 2-30 Characters (no digit)."
        } else if age.wholeMatch(of: #/^[0-9]{1,3}$/#) == nil && !((Int(age) ?? 0) > 13) {
            errorMsg = "Must be at least 13 years old."
        }
        
        // Body Stats Validation
        else if weight.wholeMatch(of: #/^[0-9]{2,3}(\\.[0-9]{1,2})?$/#) == nil {
            errorMsg = "Please input a valid weight."
        } else if height.wholeMatch(of: #/^[0-9]{2,3}$/#) == nil {
            errorMsg = "Please input a valid height (in cm)."
        } else if gender != "Male" && gender != "Female" {
            errorMsg = "Please select a gender."
        }
        
        // Nutrition Goals Validation
        else if calorieBudget.isEmpty {
            errorMsg = "Please enter a calorie budget."
        } else if Int(calorieBudget) ?? 0 < (recommendedBudget - 1000) {
            errorMsg = "Please enter a calorie budget that's \(recommendedBudget - 1000)kcal or higher."
        } else if proteinGoal.isEmpty || carbGoal.isEmpty || fatGoal.isEmpty {
            errorMsg = "Please enter all macro goals."
        } else if Int(proteinGoal) ?? 0 <= 0 || Int(carbGoal) ?? 0 <= 0 || Int(fatGoal) ?? 0 <= 0 {
            errorMsg = "Macros must be greater than 0."
        } else if totalMacroCalories > Int(calorieBudget) ?? 0 {
            errorMsg = "Macro calories exceed your calorie budget."
        } else if totalMacroCalories < (Int(calorieBudget) ?? 0) * 70 / 100 {
            errorMsg = "Macro calories seem too low compared to your budget."
        }
        
        // If Every validation passes
        else {
            errorMsg = "Successfully Submitted"
        }
        return errorMsg
    }
}
    



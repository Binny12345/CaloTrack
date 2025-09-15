//
//  FormView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/9/2025.
//

import SwiftUI

/// View to display the form for the user to fill out when registering
struct FormView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var gender: String = ""
    @State private var proteinGoal: String = ""
    @State private var carbGoal: String = ""
    @State private var fatGoal: String = ""
    @State private var weightGoal: String = ""
    @State private var calorieBudget: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMsg: String = ""
    @State private var showWelcomeMessage: Bool = false
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    let genders = [
        "-- Select Gender --",
        "Male",
        "Female"
    ]
    

    var body: some View {
        Text("Enter your Details Below")
            .font(.title2)
            .bold()
            .padding(.top, 25)
        Form {
            Section("Personal Information") {
                List {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                }
            }
            Section("Body Stats") {
                List {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.numberPad)
                    
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                    
                }
            }
            
            Section("Nutrition Goals") {
                List {
                    TextField("Calorie Budget", text: $calorieBudget)
                        .keyboardType(.numberPad)
                    TextField("Protein Goal (g)", text: $proteinGoal)
                        .keyboardType(.numberPad)
                    TextField("Carb Goal (g)", text: $carbGoal)
                        .keyboardType(.numberPad)
                    TextField("Fat Goal (g)", text: $fatGoal)
                        .keyboardType(.numberPad)
                }
            }
            
            Section("Weight Goal") {
                List {
                    TextField("Enter Your Weight Goal (g)", text: $weightGoal)
                        .keyboardType(.numberPad)
                }
            }
        }
        
        Text("Recommended Budget Based On Your Stats: \n\(recommendedBudget(age, weight, height, gender))kcal")
            .frame(alignment: .center)
            .font(.callout)
            .foregroundStyle(.secondary)
            .padding(.top, 18)
        
        Button("Submit") {
            errorMsg = inputValidation(name, age, weight, height, gender, calorieBudget, recommendedBudget: recommendedBudget(age, weight, height, gender), proteinGoal, carbGoal, fatGoal)
            
            if !errorMsg.hasSuffix("Successfully Submitted") {
                showAlert.toggle()
            } else {
                showWelcomeMessage = true
                userProfileViewModel.addUser(name, age, gender, weight, height, calorieBudget, proteinGoal, carbGoal, fatGoal, weightGoal)
            }
            
        }.alert("Alert", isPresented: $showAlert, actions: {
            // Left empty to use default "OK" action
        }, message: {
            Text(errorMsg)
        })
        .fullScreenCover(isPresented: $showWelcomeMessage) {
            Text("Welcome To CaloTrack!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 300, height: 50)
        .background(.green)
        .foregroundStyle(.white)
        .cornerRadius(10)
        .padding()
    }
    
    /// Needed to calculate the recommended calorie budget according to the user's details
    func recommendedBudget(_ age: String, _ weight: String, _ height: String, _ gender: String) -> Int {
        let age = (Int(age) ?? 0) * 5
        let weight = (Double(weight) ?? 0) * 6.25
        let height = (Int(height) ?? 0) * 10
        
        var formula = Int(weight) + height - age
        
        if gender == "Male" {
            formula += 5
        } else if gender == "Female" {
            formula -= 161
        }
        return formula
    }
    
    /// Needed to validate all the input before being submitted
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
        var errorMsg: String = ""
            let protein = Int(proteinGoal) ?? 0
            let carbs = Int(carbGoal) ?? 0
            let fats = Int(fatGoal) ?? 0
            let totalMacroCalories = (protein * 4) + (carbs * 4) + (fats * 9)
            
        
        // Personal Info Validation
        if name.wholeMatch(of: #/^[A-Za-z ]{2,30}$/#) == nil {
            errorMsg = "Name Must be 2-30 Characters."
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


//#Preview {
//    FormView()
//}

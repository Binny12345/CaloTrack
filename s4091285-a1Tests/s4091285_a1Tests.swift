//
//  s4091285_a1Tests.swift
//  s4091285-a1Tests
//
//  Created by Binyam Sisay on 4/10/2025.
//

import XCTest
import SwiftData
import FirebaseAuth
@testable import s4091285_a1

/// A suite of functional and logic-based tests to validate core components of CaloTrack.
@MainActor
final class s4091285_a1Tests: XCTestCase {
    
    var userProfileViewModel: UserProfileViewModel!
    var weightViewModel: WeightViewModel!
    var dailyLogViewModel: DailyLogViewModel!
    var formView: FormView! = nil
    
    
    /// Overrides the original function to add my VM
    @MainActor
    override func setUpWithError() throws {
        userProfileViewModel = UserProfileViewModel(mock: true)
        
        // In-memory configurations to avoid threading issues with main project
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: WeightLog.self, configurations: config)
        weightViewModel = WeightViewModel(context: container.mainContext, userID: "TEST_UID_123")
        
        // Force fetch to trigger initialization
        weightViewModel.fetchWeightLogs()
        
        dailyLogViewModel = DailyLogViewModel()
        
        formView = FormView(
            auth: AuthViewModel(),
            userProfileViewModel: userProfileViewModel,
            weightViewModel: weightViewModel,
            dailyLogViewModel: dailyLogViewModel
        )
    }

    /// Overrides the original function to set my VM to nil in case of an error
    override func tearDownWithError() throws {
        userProfileViewModel = nil
        weightViewModel = nil
        dailyLogViewModel = nil
    }
    
    
    
    /// Test 1 - FormView: Checks to ensure the profile sucessfully saves
    func testSavesUserProfileSuccessfully() async throws {
        try await userProfileViewModel.saveProfile(
            // All correct inputs
            name: "Alex",
            age: String(20),
            gender: "Male",
            weight: String(75),
            height: String(180),
            calorieBudget: String(2000),
            proteinGoal: String(150),
            carbGoal: String(100),
            fatGoal: String(100),
            weightGoal: String(65)
        )
        
        XCTAssertNotNil(userProfileViewModel.currentUser)
        XCTAssertEqual(userProfileViewModel.currentUser?.name, "Alex")
        XCTAssertEqual(userProfileViewModel.currentUser?.calorieBudget, 2000)
    }
    
    /// Test 2 - FormView: Missing name parameter stops user from saving
    func testInputValidation_RejectsEmptyName() throws {
        let message = formView.inputValidation(
            "", // Empty name input
            "25",
            "70",
            "180",
            "Male",
            "2000",
            recommendedBudget: 2000,
            "100", 
            "100",
            "50"
        )
        XCTAssertTrue(message.contains("Name Must"), "Should reject invalid or empty name.")
    }
    
    /// Test 3 - FormView: Recommended Budget for Male is Correct
    func testRecommendedBudget_MaleCalculation() throws {
        let result = formView.recommendedBudget("25", "80", "180", "Male")
        
        XCTAssertGreaterThan(result, 0)
        XCTAssertTrue(result > 1500 && result < 2500, "Male calorie budget out of expected range.")
    }
    
    /// Test 4 - FormView: Recommended Budget handles Invalid Inputs Gracefully
    func testRecommendedBudget_InvalidInput() throws {
        let result = formView.recommendedBudget("abc", "xyz", "?", "Other")
        
        XCTAssertEqual(result, 0, "Invalid numeric input should result in 0 calorie estimate.")
    }
    
    /// Test 5 - DailyLogViewModel: Verifies total calorie calculation
    func testCorrectCalorieRemainingCalculation() async throws {
        // Create mock food items
        let food1 = FoodItem(id: nil, name: "Chicken", calories: 500, protein: 40, carbs: 0, fats: 10, mealType: "Lunch", date: Date())
        let food2 = FoodItem(id: nil, name: "Rice", calories: 300, protein: 5, carbs: 60, fats: 2, mealType: "Dinner", date: Date())
        
        // Inject manually since Firestore is mocked out
        dailyLogViewModel.dailyLogs = [food1, food2]
        
        XCTAssertEqual(dailyLogViewModel.totalCaloriesToday, 800, "Total calories should sum all food entries.")
        XCTAssertEqual(dailyLogViewModel.totalProteinToday, 45, "Total protein should sum correctly.")
    }
    
    /// Test 6 - SettingsView: ClearDailyLogs should remove all current logs
    func testResetClearsUserLogs() async throws {
        let food1 = FoodItem(id: nil, name: "Apple", calories: 95, protein: 0, carbs: 25, fats: 0, mealType: "Snack", date: Date())
        let food2 = FoodItem(id: nil, name: "Egg", calories: 78, protein: 6, carbs: 1, fats: 5, mealType: "Breakfast", date: Date())
        
        dailyLogViewModel.dailyLogs = [food1, food2]
        XCTAssertEqual(dailyLogViewModel.dailyLogs.count, 2, "Should start with two logs.")
        
        do {
            await dailyLogViewModel.clearDailyLogs(testMode: true)
            print("DEBUG: \(dailyLogViewModel.dailyLogs)")
        }
        XCTAssertTrue(dailyLogViewModel.dailyLogs.isEmpty, "All daily logs should be cleared.")
    }
    
    /// Test 7 - DailyLogViewModel: Calculates correct nutrient totals with empty list
    func testCalorieAndProteinTotalsEmptyList() throws {
        dailyLogViewModel.dailyLogs = []
        XCTAssertEqual(dailyLogViewModel.totalCaloriesToday, 0, "Calories should be zero for empty logs.")
        XCTAssertEqual(dailyLogViewModel.totalProteinToday, 0, "Protein should be zero for empty logs.")
    }


}

/// Helper func which mokes the FormView file. Required as the original file requires many extra dependencies
@MainActor
private func makeMockFormView() async -> FormView {
    // Create a temporary, safe in-memory SwiftData container
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WeightLog.self, configurations: config)
    
    // Create all the ViewModels that FormView needs
    return FormView(
        auth: AuthViewModel(),
        userProfileViewModel: UserProfileViewModel(mock: true),
        weightViewModel: WeightViewModel(context: container.mainContext),
        dailyLogViewModel: DailyLogViewModel()
    )
}


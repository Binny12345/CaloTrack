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
import AVFoundation

/// A suite of functional and logic-based tests to validate core components of CaloTrack.
@MainActor
final class s4091285_a1Tests: XCTestCase {
    
    // Required Observed objects to implement test cases
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
    
    // MARK: Test Cases
    
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
        
        XCTAssertNotNil(userProfileViewModel.currentUser) // Should not be nil
        
        // Both inputs should be correct
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
        
        // Shouldn't pass as name is empty
        XCTAssertTrue(message.contains("Name Must"), "Should reject invalid or empty name.")
    }
    
    /// Test 3 - FormView: Recommended Budget for Male is Correct
    func testRecommendedBudget_MaleCalculation() throws {
        let result = formView.recommendedBudget("25", "80", "180", "Male") // Adds data for male
        
        // Both should return true
        XCTAssertGreaterThan(result, 0)
        XCTAssertTrue(result > 1500 && result < 2500, "Male calorie budget out of expected range.")
    }
    
    /// Test 4 - FormView: Recommended Budget handles Invalid Inputs Gracefully
    func testRecommendedBudget_InvalidInput() throws {
        let result = formView.recommendedBudget(
            "abc",
            "xyz",
            "?", // Invalid input
            "Other"
        )
        
        // Should equal 0
        XCTAssertEqual(result, 0, "Invalid numeric input should result in 0 calorie estimate.")
    }
    
    /// Test 5 - DailyLogViewModel: Verifies total calorie calculation
    func testCorrectCalorieRemainingCalculation() async throws {
        // Create mock food items
        let food1 = FoodItem(id: nil, name: "Chicken", calories: 500, protein: 40, carbs: 0, fats: 10, mealType: "Lunch", date: Date())
        let food2 = FoodItem(id: nil, name: "Rice", calories: 300, protein: 5, carbs: 60, fats: 2, mealType: "Dinner", date: Date())
        
        // Inject manually since Firestore is mocked out
        dailyLogViewModel.dailyLogs = [food1, food2]
        
        // both should be correct
        XCTAssertEqual(dailyLogViewModel.totalCaloriesToday, 800, "Total calories should sum all food entries.")
        XCTAssertEqual(dailyLogViewModel.totalProteinToday, 45, "Total protein should sum correctly.")
    }
    
    /// Test 6 - SettingsView: ClearDailyLogs should remove all current logs
    func testResetClearsUserLogs() async throws {
        // Create mock food items
        let food1 = FoodItem(id: nil, name: "Apple", calories: 95, protein: 0, carbs: 25, fats: 0, mealType: "Snack", date: Date())
        let food2 = FoodItem(id: nil, name: "Egg", calories: 78, protein: 6, carbs: 1, fats: 5, mealType: "Breakfast", date: Date())
        
        // Inject manually since Firestore is mocked out
        dailyLogViewModel.dailyLogs = [food1, food2]
        
        XCTAssertEqual(dailyLogViewModel.dailyLogs.count, 2, "Should start with two logs.")
        
        // Calls method using testMode "true"
        do {
            await dailyLogViewModel.clearDailyLogs(testMode: true)
        }
        
        // Should return true
        XCTAssertTrue(dailyLogViewModel.dailyLogs.isEmpty, "All daily logs should be cleared.")
    }
    
    /// Test 7 - MacroCardViewModel: Ensures extreme values are handled properly
    func testUpdateEdgeValues() {
        let macroVM = MacroCardViewModel()
        
        // calls update( ) with edge data
        macroVM.update(protein: 0, carbs: 500, fats: 200, proteinGoal: 150, carbsGoal: 500, fatsGoal: 200)
        
        // ensures each variable has been assigned the correct value
        XCTAssertEqual(macroVM.protein, 0)
        XCTAssertEqual(macroVM.carbs, 500)
        XCTAssertEqual(macroVM.fats, 200)
        XCTAssertEqual(macroVM.proteinGoal, 150)
        XCTAssertEqual(macroVM.carbsGoal, 500)
        XCTAssertEqual(macroVM.fatsGoal, 200)
    }
    
    /// Test 8 - UserProfileViewModel: Reject negative weight and height values
    func testRejectNegativeWeightAndHeight() async throws {
        // Calls saveProfile( )
        try await userProfileViewModel.saveProfile(
            name: "Alex",
            age: "25",
            gender: "Male",
            weight: "-70",   // negative weight
            height: "-180",  // negative height
            calorieBudget: "2000",
            proteinGoal: "100",
            carbGoal: "150",
            fatGoal: "70",
            weightGoal: "65"
        )
        
        XCTAssertEqual(userProfileViewModel.error, "Invalid input", "Should reject negative weight/height inputs")
        XCTAssertNil(userProfileViewModel.currentUser, "User should not be created from invalid inputs")
    }
    
    /// Test 9 - DailyLogViewModel: Handles logs with future dates gracefully
    func testDailyLogsWithFutureDates() async throws {
        // Sets future date and future food item
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let futureFood = FoodItem(id: nil, name: "FutureMeal", calories: 500, protein: 30, carbs: 40, fats: 10, mealType: "Dinner", date: futureDate)
        
        dailyLogViewModel.dailyLogs = [futureFood]
        
        // Shouldn't be able to count towards todays total calorie or logs
        XCTAssertEqual(dailyLogViewModel.totalCaloriesToday, 0, "Future-dated logs should not count towards today's totals")
        XCTAssertEqual(dailyLogViewModel.todaysLogs.count, 0, "todaysLogs should exclude future dates")
    }
    
    /// Test 10 - BarcodeViewModel: Ensures invalid barcodes are handled properly
    func testHandlesInvalidScannedBarcode() {
        class MockDelegate: BarcodeViewModelDelegate {
            var errorReceived: CameraError?
            var foundBarcode: String?
            func didFind(barcode: String) { foundBarcode = barcode }
            func didSurface(error: CameraError) { errorReceived = error }
        }
        
        // Mock Data
        let mockDelegate = MockDelegate()
        let barcodeVM = BarcodeViewModel(scannerDelegate: mockDelegate)
        
        // Pass a mock object with nil stringValue to simulate invalid scan
        let invalidMetadata = [MockBarcodeMetadata(stringValue: nil)]
        barcodeVM.handleMockMetadata(invalidMetadata)
        
        // Shouldn't have a foundBarcode and call .invalidScannedValue
        XCTAssertEqual(mockDelegate.errorReceived, .invalidScannedValue)
        XCTAssertNil(mockDelegate.foundBarcode)
    }
}


// MARK: Mock Data for Test Implementation

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

/// Mock Protocol that mimics original BarcodeMetadata for testing purposes
protocol BarcodeMetadata {
    var stringValue: String? { get }
}

/// Mock struct comforming to the protocol
struct MockBarcodeMetadata: BarcodeMetadata {
    var stringValue: String?
}

/// Extension for BarcodeViewModel to handle mock metadata objects
extension BarcodeViewModel {
    
    /// This function mimics the real metadataOutput for testing.
    /// - Parameter metadataObjects: Array of mock metadata objects
    func handleMockMetadata(_ metadataObjects: [BarcodeMetadata]) {
        
        // Grab the first object if it exists
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // Grab the barcode string value from mock object
        guard let barcode = object.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // if valid, send barcode to delegate
        scannerDelegate?.didFind(barcode: barcode)
    }
}


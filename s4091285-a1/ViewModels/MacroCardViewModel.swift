//
//  MacroCardViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 16/9/2025.
//

import Foundation

/// Required to manage the different Macro cards on the dashboard
class MacroCardViewModel: ObservableObject {
    
    /// Style enum for differentiating the different card styles
    enum Style {
        case bars, rings
    }
    
    /// State variables for the user's macros and macro goals
    @Published var currentStyle: Style = .bars
    @Published var protein: Int = 0
    @Published var carbs: Int = 0
    @Published var fats: Int = 0
    @Published var proteinGoal: Int = 0
    @Published var carbsGoal: Int = 0
    @Published var fatsGoal: Int = 0
    
    /// Used to switch between the two styles using Combined Gesture
    /// - Parameter upwards: Checks if the user is asking to change style
    func switchStyle(upwards: Bool = true) {
        let styles: [Style] = [.bars, .rings]
        guard let index = styles.firstIndex(of: currentStyle) else { return }
        let newIndex = upwards
            ? (index + 1) % styles.count
            : (index - 1 + styles.count) % styles.count
        currentStyle = styles[newIndex]
    }
    
    /// Used to update the macro count of the user, based on newly input food logs
    /// - Parameter protein: Protein count of the user
    /// - Parameter carbs: Carb count of the user
    /// - Parameter fats: Fat count of the user
    /// - Parameter proteinGoal: Protein goal that the user inputted
    /// - Parameter carbsGoal: Carb goal that the user inputted
    /// - Parameter fatsGoal: Fat goal that the user inputted
    func update(protein: Int, carbs: Int, fats: Int,
                proteinGoal: Int, carbsGoal: Int, fatsGoal: Int) {
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.proteinGoal = proteinGoal
        self.carbsGoal = carbsGoal
        self.fatsGoal = fatsGoal
    }
}

//
//  MacroCardViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 16/9/2025.
//

import Foundation

class MacroCardViewModel: ObservableObject {
    
    enum Style {
        case bars, rings
    }
    @Published var currentStyle: Style = .bars
    
    @Published var protein: Int = 0
    @Published var carbs: Int = 0
    @Published var fats: Int = 0
    
    @Published var proteinGoal: Int = 0
    @Published var carbsGoal: Int = 0
    @Published var fatsGoal: Int = 0
    
    func switchStyle(upwards: Bool = true) {
        let styles: [Style] = [.bars, .rings]
        guard let index = styles.firstIndex(of: currentStyle) else { return }
        let newIndex = upwards
            ? (index + 1) % styles.count
            : (index - 1 + styles.count) % styles.count
        currentStyle = styles[newIndex]
    }
    
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

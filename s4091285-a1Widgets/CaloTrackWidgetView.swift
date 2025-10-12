//
//  CaloTrackWidgetEntryView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 11/10/2025.
//

import Foundation
import WidgetKit
import SwiftUI

struct CaloTrackWidgetView: View {
    
    /// Variable created from CalorieEntry Model
    var entry: CalorieEntry
    
    /// Env variable of the different widget sizes
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallCalorieRing(entry: entry)
        default:
            MediumCalorieAndMacrosView(entry: entry)
        }
    }
}

/// Defines the UI of the small Widget (Calories only)
struct SmallCalorieRing: View {
    /// Variable created from CalorieEntry Model
    var entry: CalorieEntry
    
    var progress: Double {
        guard entry.calorieGoal > 0 else { return 0 }
        return min(entry.caloriesConsumed / entry.calorieGoal, 1.0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.gray)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(progress >= 1.0 ? .red : .green)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            VStack {
                Text("\(Int(entry.caloriesConsumed))")
                    .font(.title2)
                    .bold()
                Text("/ \(Int(entry.calorieGoal))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

/// Defines the UI of the Medium Widget (Calories and Macros)
struct MediumCalorieAndMacrosView: View {
    /// Variable created from CalorieEntry Model
    var entry: CalorieEntry
    
    var body: some View {
        HStack(spacing: 12) {
            SmallCalorieRing(entry: entry)
                .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 4) {
                MacroBar(label: "Protein", value: entry.protein, max: 150, color: .blue)
                MacroBar(label: "Carbs", value: entry.carbs, max: 200, color: .orange)
                MacroBar(label: "Fats", value: entry.fats, max: 70, color: .pink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

/// Helper struct to display individual macro bars
struct MacroBar: View {
    let label: String
    let value: Double
    let max: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.caption)
                    .bold()
                Spacer()
                Text("\(Int(value))/\(Int(max))g")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 6)
                        .foregroundColor(Color.gray.opacity(0.2))
                    Capsule()
                        .frame(width: geo.size.width * CGFloat(min(value / max, 1.0)), height: 6)
                        .foregroundColor(color)
                }
            }
            .frame(height: 6)
        }
    }
}

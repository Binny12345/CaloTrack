//
//  MacroCardView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 16/9/2025.
//

import SwiftUI
import Charts

/// Displays macros (protein, carbs, fats) either as progress bars or rings, depending on gesture input.
struct MacroCardView: View {
    
    // State and observed variables
    @ObservedObject var viewModel: MacroCardViewModel
    @State private var isPressed: Bool = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack {
            ZStack {
                // Displays each view using a transition animation
                if viewModel.currentStyle == .bars {
                    barsView
                        .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    ringsView
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            // Feedback on long press
            .scaleEffect(isPressed ? 1.05 : 1.0)
            
            // Follows finger while dragging
            .offset(dragOffset)
            .animation(.spring(), value: isPressed)
            .animation(.easeInOut, value: dragOffset)
            
            // Page indicators
            HStack(spacing: 8) {
                Circle()
                    .fill(viewModel.currentStyle == .bars ? .green : .gray)
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(viewModel.currentStyle == .rings ? .green : .gray)
                    .frame(width: 10, height: 10)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: isPressed ? 5 : 1)
        
        // Combined Gesture
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .sequenced(before: DragGesture(minimumDistance: 20))
                .onChanged { value in
                    switch value {
                    case .first(true):
                        // Long press feedback
                        isPressed = true
                    case .second(true, let drag?):
                        // Follow finger while dragging
                        dragOffset = drag.translation
                    default:
                        break
                    }
                }
                .onEnded { value in
                    switch value {
                    case .second(true, let drag?):
                        // Interpret drag direction
                        if drag.translation.height < 0 {
                            withAnimation {
                                viewModel.switchStyle(upwards: true)
                            }
                        } else {
                            withAnimation {
                                viewModel.switchStyle(upwards: false)
                            }
                        }
                    default:
                        break
                    }
                    // Reset states
                    isPressed = false
                    dragOffset = .zero
                }
        )
    }
    // Variable that holds each Macro as a bar display
    private var barsView: some View {
        VStack {
            ProgressView("Protein: \(Int(viewModel.protein))g of \(Int(viewModel.proteinGoal))g", value: Double(viewModel.protein), total: Double(viewModel.proteinGoal))
                .tint(.green)
            ProgressView("Carbs: \(Int(viewModel.carbs))g of \(Int(viewModel.carbsGoal))g", value: Double(viewModel.carbs), total: Double(viewModel.carbsGoal))
                .tint(.green)
            ProgressView("Fats: \(Int(viewModel.fats))g of \(Int(viewModel.fatsGoal))g", value: Double(viewModel.fats), total: Double(viewModel.fatsGoal))
                .tint(.green)
        }
    }
    
    // Variable that holds each Macro as a ring display
    private var ringsView: some View {
        HStack {
            RingView(value: Double(viewModel.protein), total: Double(viewModel.proteinGoal), label: "Protein")
            RingView(value: Double(viewModel.carbs), total: Double(viewModel.carbsGoal), label: "Carbs")
            RingView(value: Double(viewModel.fats), total: Double(viewModel.fatsGoal), label: "Fats")
        }
    }
}



/// Reusable subview that draws one macro’s progress as a circular ring.
struct RingView: View {
    let value: Double
    let total: Double
    let label: String
    
    var body: some View {
        ZStack {
            // Grey Inner Circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
            
            // Green/Red Outter Circle
            Circle()
                .trim(from: 0, to: value / total)
                .stroke(value > total ? .red : .green,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack() {
                Text("\(Int(value)) / \(Int(total)) g")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 100, height: 100)
        .padding(2.5)
    }
}



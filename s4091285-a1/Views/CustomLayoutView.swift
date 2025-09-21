//
//  CustomLayoutView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 19/8/2025.
//

import SwiftUI
import Charts

/// Custom SwiftUI Layout to arrange its children, a welcome message mentioning user by name
struct CustomLayoutView: Layout {
    var spacing: CGFloat = 12
    
    /// Decides how big the container should be based on it's children
    /// - Parameter proposal: suggests how big this container could be
    /// - Parameter subviews: A collection of child views inside this layout
    /// - Parameter cache: stores intermediate calculations between `sizeThatFits` and `placeSubviews`
    /// - Returns: Total size this layout requires
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        // Decide how big the container is
        let maxWidth = proposal.width ?? 0
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        // Sets the size
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            totalWidth += size.width
            maxHeight = max(maxHeight, size.height)
            
            if index < subviews.count - 1 {
                totalWidth += spacing
            }
        }
        
        return CGSize(
            width: min(totalWidth, maxWidth),
            height: maxHeight
        )
    }
    
    /// Used to actually position each subview within the container
    /// - Parameter bounds: The rectangle this layout can draw within, given by the parent.
    /// - Parameter proposal: suggests how big this container could be
    /// - Parameter subviews: A collection of child views inside this layout
    /// - Parameter cache: stores intermediate calculations between `sizeThatFits` and `placeSubviews`
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        var currentX = bounds.minX
        let centerY = bounds.midY
        
        // Places the subview inside the bounds set
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let yPosition = centerY - (size.height / 2)
            
            subview.place(
                at: CGPoint(x: currentX, y: yPosition),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
        }
    }
}

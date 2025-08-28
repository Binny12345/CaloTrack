//
//  CustomLayoutView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 19/8/2025.
//

import SwiftUI
import Charts

/// Custom Layout, Personal welcome message to user, mentions name of user
struct CustomLayoutView: Layout {
    var spacing: CGFloat = 12
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxWidth = proposal.width ?? 0
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
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
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        var currentX = bounds.minX
        let centerY = bounds.midY
        
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

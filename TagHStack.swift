//
//  TagHStack.swift
//  
//
//  Created by 멘태 on 8/26/25.
//


import SwiftUI

struct TagGroup: Layout {
    let spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxWidth: CGFloat = proposal.width ?? .greatestFiniteMagnitude
        var totalHeight: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var maxUsedWidth: CGFloat = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let needsSpacing = index > 0 && currentRowWidth > 0
            let requiredWidth = currentRowWidth + (needsSpacing ? spacing : 0) + size.width
            
            if requiredWidth > maxWidth && currentRowWidth > 0 {
                // 줄바꿈 필요
                maxUsedWidth = max(maxUsedWidth, currentRowWidth)
                totalHeight += (totalHeight > 0 ? spacing : 0) + size.height
                currentRowWidth = size.width
            } else {
                // 현재 줄에 추가
                if totalHeight == 0 {
                    totalHeight = size.height
                }
                currentRowWidth += (needsSpacing ? spacing : 0) + size.width
            }
        }
        
        // 마지막 줄의 너비도 체크
        maxUsedWidth = max(maxUsedWidth, currentRowWidth)
        
        return CGSize(width: min(maxUsedWidth, maxWidth), height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let needsSpacing = index > 0 && currentX > bounds.minX
            let requiredWidth = currentX + (needsSpacing ? spacing : 0) + size.width
            
            if requiredWidth > bounds.maxX && currentX > bounds.minX {
                // 줄바꿈
                currentX = bounds.minX
                currentY += size.height + spacing
            } else if needsSpacing {
                currentX += spacing
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width
        }
    }
}

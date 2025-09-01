//
//  PrimaryButton.swift
//  profile
//
//  Created by 멘태 on 8/28/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    init(title: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 54 / 2))
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .frame(height: 54)
    }
}

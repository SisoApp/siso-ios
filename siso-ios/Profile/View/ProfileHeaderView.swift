//
//  SignUpHeaderView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    let progress: Float
    
    var body: some View {
        Text("내 정보 입력")
            .font(.title3)
            .bold()
        
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(.linear)
            .tint(.black)
            .padding()
    }
}

#Preview {
    ProfileHeaderView(progress: 0.0)
}

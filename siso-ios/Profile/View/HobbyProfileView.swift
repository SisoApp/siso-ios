//
//  HobbyProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct HobbyProfileView: View {
    private let viewModel: HobbyProfileViewModel = HobbyProfileViewModel()
    
    var body: some View {
        ProfileHeaderView(
            page: 2,
            title: "나의 관심사를 선택해주세요",
            subTitle: "최소 3개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
        )
        
        Spacer()
        
        Button("계속하기") {
            
        }
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .foregroundStyle(.black)
        .clipShape(.rect(cornerRadius: 27))
        .padding()
    }
}

#Preview {
    HobbyProfileView()
}

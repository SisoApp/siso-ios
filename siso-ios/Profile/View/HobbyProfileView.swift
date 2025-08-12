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
        ProfileHeaderView(page: 2)
        
        Text("나의 관심사를 선택해주세요")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
        
        Text("최소 3개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        Spacer()
        
        Button("계속하기") {
            
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .foregroundStyle(.black)
        .clipShape(.rect(cornerRadius: 20))
        .padding()
    }
}

#Preview {
    HobbyProfileView()
}

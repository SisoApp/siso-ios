//
//  HobbyProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

public struct HobbyProfileView: View {
    public var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    public var body: some View {
        ProfileHeaderView(progress: 2/7)
        
        Text("나의 관심사를 선택해주세요")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
        
        Text("최소 1개 이상 선택해주세요")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        Spacer() // 버튼이 들어가야함(LazyHGrid?)
        
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

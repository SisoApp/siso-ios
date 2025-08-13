//
//  HobbyProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI
import designSystem

public struct HobbyProfileView: View {
    public var delegate: ProfileCoordinatorDelegate?
    private let viewModel: HobbyProfileViewModel = HobbyProfileViewModel()
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 2,
                title: "나의 관심사를 선택해주세요",
                subTitle: "최소 3개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
            )
            
            Spacer()
            
            Button("계속하기") {
                delegate?.pushProfile(.image)
            }
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .foregroundStyle(.black)
            .clipShape(.rect(cornerRadius: 27))
            .padding()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        delegate?.pop()
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HobbyProfileView(delegate: nil)
    }
}

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
    
    private var isActive: Bool {
        return true
    }
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 2,
                title: "나의 관심사를 선택해주세요",
                subTitle: "최소 3개 이상 선택해주세요\n많이 고를수록 매칭 확률이 높아져요\n정보는 나중에 수정할 수 있어요"
            )
            
            ScrollView {
                
            }
            
            nextButton()
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
    
    private func nextButton() -> some View {
        return Button {
            delegate?.pushProfile(.image)
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            isActive ? Color.Siso.Primary._80 : Color.Siso.Gray._40,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .padding()
    }
}

#Preview {
    NavigationStack {
        HobbyProfileView(delegate: nil)
    }
}

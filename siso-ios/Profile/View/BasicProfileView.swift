//
//  BasicProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

public struct BasicProfileView: View {
    @State private var nickname: String = ""
    public var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 1,
                title: "기본 정보를 입력해주세요",
                subTitle: ""
            )
            
            textFieldView(field: "닉네임", placeholder: "이것은 닉네임입니다.")
            
            textFieldView(field: "나이", placeholder: "나이를 입력해주세요.")
            
            // 라디오 버튼에서 선택한 값을 저장해야함
            
            RadioButtonGroup(title: "내 성별", options: ["여성", "남성"])
            
            RadioButtonGroup(title: "매칭 성별", options: ["동성", "이성"])
            
            Spacer()
            
            Button("계속하기") {
                delegate?.pushProfile(.hobby)
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
    }
    
    private func textFieldView(field: String, placeholder: String) -> some View {
        return VStack {
            Text(field)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            TextField(placeholder, text: $nickname)
                .frame(height: 48)
                .padding(.horizontal, 8)
                .background(.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 12))
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
    }
}

#Preview {
    NavigationStack {
        BasicProfileView(delegate: nil)
    }
}

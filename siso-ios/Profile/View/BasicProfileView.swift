//
//  BasicProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct BasicProfileView: View {
    @State private var nickname: String = ""
    
    var body: some View {
        ProfileHeaderView(page: 1)
        
        Text("기본 정보를 입력해주세요")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        Text("닉네임")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        
        TextField("이것은 닉네임입니다.", text: $nickname)
            .frame(height: 40)
            .padding(.horizontal, 8)
            .background(.gray.opacity(0.2))
            .clipShape(.rect(cornerRadius: 12))
            .padding()
        
        // 라디오 버튼에서 선택한 값을 저장해야함
        
        RadioButtonGroup(title: "내 성별", options: ["여성", "남성"])
        
        RadioButtonGroup(title: "매칭 성별", options: ["여성", "남성"])
        
        Text("나이")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        Text("키")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
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
    BasicProfileView()
}

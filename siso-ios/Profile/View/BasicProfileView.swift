//
//  BasicProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct BasicProfileView: View {
    @State private var progress: Float = 0.2
    @State private var nickname: String = ""
    
    var body: some View {
        Text("내 정보 입력")
            .font(.title3)
            .bold()
        
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(.linear)
            .tint(.black)
            .padding()
        
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
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        
        Text("내 성별")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        Text("매칭 성별")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
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
        .background(.gray)
        .foregroundStyle(.black)
        .clipShape(.rect(cornerRadius: 20))
        .padding()
    }
}

#Preview {
    BasicProfileView()
}

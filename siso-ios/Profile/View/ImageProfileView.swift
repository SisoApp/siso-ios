//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI

struct ImageProfileView: View {
    var body: some View {
        ProfileHeaderView(page: 3)
        
        Text("나를 표현하는 사진을 보여주세요")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
        
        Text("최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요")
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        RoundedRectangle(cornerRadius: 24)
            .fill(.gray.opacity(0.2))
            .frame(height: 206)
            .padding(.vertical, 32)
            .padding(.horizontal)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
            }
        
        Spacer()
        
        Button("사진 추가하기") {
            
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
    ImageProfileView()
}

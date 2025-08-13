//
//  SignUpHeaderView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    let page: Int
    let title: String
    let subTitle: String
    let mainColor: Color = Color(red: 1.0, green: 0.843, blue: 0.0).opacity(0.4)
    let textColor: Color = .gray.opacity(0.5)
    let gray: Color = .gray.opacity(0.3)
    
    var body: some View {
        Text("내 정보 입력")
            .font(.title3)
            .bold()
        
        HStack {
            Circle()
                .fill(page == 1 ? mainColor : gray)
                .frame(width: 36)
                .overlay {
                    Text("1")
                        .foregroundStyle(page == 1 ? .black : textColor)
                }
                
            RoundedRectangle(cornerRadius: 12)
                .fill(gray)
                .frame(height: 5)
            
            Circle()
                .fill(page == 2 ? mainColor : gray)
                .frame(width: 36)
                .overlay {
                    Text("2")
                        .foregroundStyle(page == 2 ? .black : textColor)
                }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(gray)
                .frame(height: 5)
            
            Circle()
                .fill(page == 3 ? mainColor : gray)
                .frame(width: 36)
                .overlay {
                    Text("3")
                        .foregroundStyle(page == 3 ? .black : textColor)
                }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(gray)
                .frame(height: 5)
            
            Circle()
                .fill(page == 4 ? mainColor : gray)
                .frame(width: 36)
                .overlay {
                    Text("4")
                        .foregroundStyle(page == 4 ? .black : textColor)
                }
        }
        .padding()
        
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
        
        Text(subTitle)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

#Preview {
    ProfileHeaderView(
        page: 1,
        title: "기본 정보를 입력해주세요",
        subTitle: "최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
    )
}

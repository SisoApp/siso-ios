//
//  SignUpHeaderView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    let currentPage: Int
    let title: String
    let subTitle: String
    let mainColor: Color = Color(red: 1.0, green: 0.843, blue: 0.0).opacity(0.4)
    let textColor: Color = .gray.opacity(0.5)
    let gray: Color = .gray.opacity(0.3)
    
    var body: some View {
        HStack {
            circleView(page: 1)
                
            lineView()
            
            circleView(page: 2)
            
            lineView()
            
            circleView(page: 3)
            
            lineView()
            
            circleView(page: 4)
        }
        .padding()
        
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
        
        Text(subTitle)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private func circleView(page: Int) -> some View {
        return Circle()
            .fill(page == currentPage ? .yellow : gray)
            .frame(width: 36)
            .overlay {
                Text(page.description)
                    .foregroundStyle(page == 1 ? .black : textColor)
            }
    }
    
    private func lineView() -> some View {
        return RoundedRectangle(cornerRadius: 12)
            .fill(gray)
            .frame(height: 5)
    }
}

#Preview {
    ProfileHeaderView(
        currentPage: 1,
        title: "기본 정보를 입력해주세요",
        subTitle: "최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
    )
}

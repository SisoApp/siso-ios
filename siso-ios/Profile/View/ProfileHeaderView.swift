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
    
    var body: some View {
        HStack {
            circleView(page: 1)
            lineView(page: 2)
            circleView(page: 2)
            lineView(page: 3)
            circleView(page: 3)
            lineView(page: 4)
            circleView(page: 4)
        }
        .padding()
        
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
        
        Text(subTitle)
            .foregroundStyle(Color.Siso.Gray._60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private func circleView(page: Int) -> some View {
        return Circle()
            .fill(page <= currentPage ? Color.Siso.Primary.main : .Siso.Gray._30)
            .frame(width: 36)
            .overlay {
                Text(page.description)
                    .foregroundStyle(page <= currentPage ? .black : .Siso.Gray._50)
            }
    }
    
    private func lineView(page: Int) -> some View {
        return RoundedRectangle(cornerRadius: 12)
            .fill(page <= currentPage ? Color.Siso.Primary.main :  Color.Siso.Gray._30)
            .frame(height: 4)
            .padding(.horizontal, 6)
    }
}

#Preview {
    ProfileHeaderView(
        currentPage: 1,
        title: "기본 정보를 입력해주세요",
        subTitle: "최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
    )
}

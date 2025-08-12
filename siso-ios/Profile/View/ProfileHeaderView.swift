//
//  SignUpHeaderView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    let page: Int
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
    }
}

#Preview {
    ProfileHeaderView(page: 1)
}

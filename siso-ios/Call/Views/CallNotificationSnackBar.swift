//
//  CallNotificationToastView.swift
//  call
//
//  Created by jdios on 8/22/25.
//

import SwiftUI
import model

struct CallNotificationSnackBar: View {
    var profile: CallInfoDto
    var body: some View {
        VStack {
            HStack {
                profileImageAnimatedView(profile: profile)
                VStack(alignment: .leading) {
                    Text(profile.nickname)
                    Text("님으로부터\n전화가 걸려왔어요.")
                }
                Spacer()
            }
            HStack(spacing: 10) {
                Button {
                    print("call reject")
                } label: {
                    Image("quitcallicon")
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.red)
                        )
                        .frame(maxWidth: .infinity)
                    
                }
                
                Button {
                    print("accept call")
                } label: {
                    Image("phoneicon")
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.red)
                        )
                        .frame(maxWidth: .infinity)
                }


            }
        }
        .frame(height: 200)
        
        
    }
    
    /// 프로필 이미지를 표시하는 뷰
    private func profileImageAnimatedView(profile: CallInfoDto) -> some View {
        // profileImageUrls 배열의 첫 번째 이미지를 사용하되, nil-coalescing으로 안전하게 처리합니다.
        // URL(string:) 생성자도 옵셔널을 반환하므로 if let으로 처리하는 것이 더 안전합니다.
        let imageUrl = URL(string: profile.profileImageUrl ?? "")
        
        return AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            // 이미지가 로드되기 전이나 URL이 유효하지 않을 때 표시될 뷰
            Circle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
        }
        .frame(width: 180, height: 180)
        .clipShape(Circle())
        .shadow(radius: 5) // 약간
    }
}


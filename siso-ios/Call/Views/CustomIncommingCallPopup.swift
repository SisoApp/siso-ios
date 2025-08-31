//
//  CustomIncommingCallPopup.swift
//  call
//
//  Created by jdios on 8/31/25.
//

import SwiftUI
import model
import designSystem

public struct CustomIncommingCallPopup: View {
    let incommingCall: CallInfoDto
    
    public var body: some View {
        VStack {
            HStack {
                profileImageView
                
                Text("\(incommingCall.nickname)님으로부터\n전화가 걸려왔어요")
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(.black)
            }
            actionButtonsSection
        }
        
    }
    private var profileImageView: some View {
        ZStack {
            AsyncImage(url: URL(string: incommingCall.profileImageUrl ?? "https://imgur.com/a/24214AF")){ image in
                
                image
                    .resizable() // 1. 크기 조절 가능하게 설정 (필수!)
                    .scaledToFill() // 2. 프레임을 꽉 채우도록 비율 유지 (프로필 사진에 필수!)
                    .frame(width: 140, height: 140) // 3. 프레임 크기 지정
                    .clipShape(Circle()) // 4. 원형으로 자르기
                
            } placeholder: {
                Circle()
                    .frame(width: 140, height: 140) // 3. 프레임 크기 지정
            }
        }
    }
    private var actionButtonsSection: some View {
        HStack {
            Button {
                print("receiver reject Call")
                Task {
                    
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .foregroundStyle(Color.Siso.Red._60)
                    .overlay {
                        Image("quitcallicon")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
            }
            
            Spacer()
            
            Button {
                print("receiver accept call")
                Task {
                    await CallManager.shared.acceptCall()
                }
               
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .foregroundStyle(Color.Siso.Green._60)
                    .overlay {
                        Image("phoneicon")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
            }
        }
        .frame(height: 45)
        .padding(.horizontal)
    }
}

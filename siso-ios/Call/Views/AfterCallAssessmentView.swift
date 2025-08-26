//
//  AfterCallAssessmentView.swift
//  call
//
//  Created by jdios on 8/24/25.
//

import SwiftUI
import model

public struct AfterCallAssessmentView: View {
    var opponentProfile: UserProfileServer
    
    public init(opponentProfile: UserProfileServer){
        self.opponentProfile = opponentProfile
    }
    public var body: some View {
        
        VStack(spacing: 30) {
            Spacer()
            
            VStack{
                profileImageView
                
                HStack {
                    Text("\(opponentProfile.nickname),")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black)
                    Text("\(opponentProfile.age)세")
                        .foregroundStyle(Color.Siso.Gray._60)
                        .font(.system(size: 24, weight: .bold))
                }
                
            }
            
            VStack {
                Text("\(opponentProfile.nickname)님과의 통화는 어땠나요?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding()
                
                
                HStack {
                    Button {
                        print("deny")
                    } label: {
                        denyButton
                    }

                    Button {
                        print("accept")
                    } label: {
                        loveButton
                    }
                }
            }
            
            Spacer()
            
            Button {
                print("sue")
            } label: {
                Text("신고하기")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.Siso.Gray._60)
            }

            
        }
    }
    
    private var denyButton: some View {
        ZStack {
            Rectangle()
                .frame(width: 143, height: 143)
                .foregroundStyle(.white)
                .overlay(
                    // 테두리 역할을 할 둥근 사각형
                    RoundedRectangle(cornerRadius: 12) // 배경과 같은 값으로 설정
                        .stroke(Color.Siso.Gray._30, lineWidth: 1)
                )
            
            Image("denylove")
                .resizable()
                .frame(width: 60, height: 60)
        }
        
    }
    
    private var loveButton: some View {
        ZStack {
            Rectangle()
                .frame(width: 143, height: 143)
                .foregroundStyle(.white)
                .overlay(
                    // 테두리 역할을 할 둥근 사각형
                    RoundedRectangle(cornerRadius: 12) // 배경과 같은 값으로 설정
                        .stroke(Color.Siso.Gray._30, lineWidth: 1)
                )
            Image("sendlove")
                .resizable()
                .frame(width: 60, height: 60)
        }
        
    }
    private var profileImageView: some View {
        ZStack {
            
            AsyncImage(url: URL(string: opponentProfile.profileImageUrls.first ?? "testimg")){ image in
                
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
    
}


#Preview {
    AfterCallAssessmentView(opponentProfile: UserProfileServer.sampleMessi)
}

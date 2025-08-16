//
//  AfterCallPopup.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

struct AfterCallPopup: View {
    @StateObject var cardViewModel: CardViewModel
    var body: some View {
        
        VStack {
            profileImageAnimatedView
            
            Text("\(cardViewModel.nickname)님과의 통화는 어땠나요?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
                .padding()
            
            Text("인연 이어가기를 누르면\n메시지를 보내고 상대의\n자세한 정보를 확인할 수 있어요")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            HStack {
                
                Button {
                    print("sue")
                } label: {
                    Text("신고하기")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .padding()
                }
                
                Button {
                    print("인연 이어가기")
                } label: {
                    Text("인연 이어가기")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 90)
                                .foregroundStyle(Color.Siso.Primary._40)
                        }
                }

            }
            .padding()
        }
    }
    
    private var profileImageAnimatedView: some View {
        ZStack {
            
            AsyncImage(url: cardViewModel.profileImages.first){ image in
                
                image
                    .resizable() // 1. 크기 조절 가능하게 설정 (필수!)
                    .scaledToFill() // 2. 프레임을 꽉 채우도록 비율 유지 (프로필 사진에 필수!)
                    .frame(width: 180, height: 180) // 3. 프레임 크기 지정
                    .clipShape(Circle()) // 4. 원형으로 자르기
                
            } placeholder: {
                Circle()
                    .frame(width: 180, height: 180) // 3. 프레임 크기 지정
            }
        }
        
        
    }
    
}

#Preview {
    AfterCallPopup(cardViewModel: CardViewModel.testModel)
}

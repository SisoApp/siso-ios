//
//  AfterCallAssessmentView.swift
//  call
//
//  Created by jdios on 8/24/25.
//
import network
import SwiftUI
import model
import matching

public struct AfterCallAssessmentView: View {
    var opponentProfile: MatchingProfile
    var callInfo: CallInfoDto // ✅ callInfo도 함께 받아야 함
    var delegate: CallCoordinatorDelegate?
    
    public init(opponentProfile: MatchingProfile, callInfo: CallInfoDto, delegate: CallCoordinatorDelegate? = nil) {
        self.opponentProfile = opponentProfile
        self.callInfo = callInfo
        self.delegate = delegate
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
                        print("User chose NOT to continue relationship.")
                        // ✅ 1. CallManager에게 최종 결정(false)을 알림
                        Task {
                            await CallManager.shared.decideRelationship(continueRelationship: false)
                        }
                        // ✅ 2. Coordinator를 통해 홈 화면 등으로 이동
                        //    decideRelationship이 callState를 .idle로 바꾸면
                        //    ActiveCallView가 알아서 dismissCallFlow를 호출하므로,
                        //    여기서는 추가적인 화면 전환(popToRoot 등)만 처리하면 됨.
                        
                        delegate?.dismissCallFlow()
                    } label: {
                        denyButton
                    }
                    
                    Button {
                        print("accept")
                        Task {
                            await CallManager.shared.decideRelationship(continueRelationship: true)
                        }
                    } label: {
                        loveButton
                    }
                }
            }
            
            Spacer()
            
            Button {
              
                Task {
                    await CallManager.shared.decideRelationship(continueRelationship: true)
                }
                
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
            VStack{
                Image("denylove")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("다른 인연 찾기")
                    .foregroundStyle(.black)
            }
            
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
            VStack {
                Image("sendlove")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("인연 이어가기")
                    .foregroundStyle(.black)
            }
            
        }
        
    }
    private var profileImageView: some View {
        ZStack {
            
            AsyncImage(url: URL(string: opponentProfile.imageUrls.first ?? "testimg")){ image in
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                
            } placeholder: {
                Circle()
                    .frame(width: 140, height: 140) // 3. 프레임 크기 지정
            }
        }
    }
}

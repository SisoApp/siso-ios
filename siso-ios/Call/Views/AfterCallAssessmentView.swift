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
    var callInfo: CallInfoDto 
    var delegate: CallCoordinatorDelegate
    
    @EnvironmentObject var callManager: CallManager
    @State var isReported: Bool = false
    
    public init(opponentProfile: MatchingProfile, callInfo: CallInfoDto, delegate: CallCoordinatorDelegate) {
        self.opponentProfile = opponentProfile
        self.callInfo = callInfo
        self.delegate = delegate
    }
    
    public var body: some View {
        ZStack {
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
                            Task {
                                await callManager.decideRelationship(continueRelationship: false)
                            }
                            delegate.dismissCallFlow()
                        } label: {
                            denyButton
                        }
                        
                        Button {
                            print("accept")
                            Task {
                                await callManager.decideRelationship(continueRelationship: true)
                            }
                        } label: {
                            loveButton
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    // 리포트 화면 호출
                    delegate.openReportSheet(.report(opponentProfile: opponentProfile))
                    
                } label: {
                    Text("신고하기")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.Siso.Gray._60)
                }
            }
            if callManager.reportSuccessfullyEnded {
                ReportFeedBackView(delegate: delegate)
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

//
//  ProfileDemandingView.swift
//  matching
//
//  Created by jdios on 8/23/25.
//

import SwiftUI
import designSystem

public struct ProfileDemandingView: View {
    @ObservedObject var matchingViewModel: MatchingViewModel
    var delegate: MatchingCoordinatorDelegate?
    
    public init(matchingViewModel: MatchingViewModel, delegate: MatchingCoordinatorDelegate? = nil) {
        self.matchingViewModel = matchingViewModel
        self.delegate = delegate
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        matchingViewModel.isProfileWriteDemanded = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12,height: 12)
                            .padding()
                            .foregroundStyle(Color.Siso.Gray._90)
                    }
                }
                
                Spacer()
                
                Image("peopleCircle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 186, height: 80)
                    .padding()
                
                Spacer()
                
                Text("상세 프로필을 작성하면\n나와 맞는 인연을\n만날 확률이\n5배 높아져요")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack{
                    Button {
                        print("상세 프로필 작성하러 가기")
                        matchingViewModel.isProfileWriteDemanded = false
                        delegate?.changeMatchingToProfile()
                        
                        // TODO: 상세 프로필 작성하는 마이페이지로 이동
                    } label: {
                        Text("상세 프로필 작성하러 가기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(Color.Siso.Primary._40)
                            )
                            .padding(.horizontal)
                    }
                    
                    Button {
                        matchingViewModel.isProfileWriteDemanded = false
                    } label: {
                        Text("닫기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.Siso.Gray._50)
                            .padding()
                        
                    }
                }
            }
            .frame(width: 283, height: 474)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
            )
        }
    }
}

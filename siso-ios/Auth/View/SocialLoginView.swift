//
//  LoginView.swift
//  auth
//
//  Created by jdios on 8/9/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import designSystem

public struct SocialLoginView: View {
    @EnvironmentObject private var vm: SocialLoginView.LoginViewModel
    var delegate: AuthCoordinatorDelegate?
    
    public init(delegate: AuthCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Image("bgLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Image("Vector")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 18.2)
                    .rotationEffect(Angle(degrees: -18.61))
                
                VStack(alignment: .leading) {
                    Spacer()
                    Group {
                        Text("지금도,\n사랑하기 딱 좋은 나이")
                            .font(.appFont(name: .regular, size: 32))
                            .foregroundStyle(Color.Siso.Orange._100)
                        Text("시팅")
                            .font(.appFont(name: .regular, size: 72))
                            .foregroundStyle(Color.Siso.Orange._100)
                    }
                    Spacer()
                    Spacer()
                    
                    loginButton(title: "카카오로 시작하기", icon: "KaKao", bgColor: Color(hex: "FEE500"), textColor: .black) {
                        Task {
                            await vm.kakaoLogin() { state in
                                if state == "LOGIN" {
                                    delegate?.changeAuthToMatching()
                                } else if state == "REGISTER" {
                                    delegate?.pushAuth(.accept)
                                } else {
                                    print("userState가 ''가 되는 곳")
                                }
                            }
                        }
                    }
                    loginButton(title: "Apple로 시작하기", icon: "Apple" , bgColor: .black, textColor: .white) {
                        // Apple Login
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .onChange(of: vm.userState) {
            if vm.userState == "LOGIN" {
                delegate?.changeAuthToMatching()
            } else if vm.userState == "REGISTER" {
                delegate?.pushAuth(.accept)
            }
        }
    }
    
    // TODO: 로그인 버튼 뷰
    private func loginButton(title: String, icon: String ,bgColor: Color, textColor: Color,action: @escaping () -> Void) -> some View {

        Button {
            action()
        } label: {
            Label(title, image: icon)
                .labelStyle(.titleAndIcon)
                .frame(maxWidth: .infinity)
                .padding()
                .background(bgColor)
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(textColor)
        }
        .font(.custom("AppleSDGothicNeo-Medium", size: 15))
        .fontWeight(.semibold)
    }
}

#Preview {
    SocialLoginView(delegate: nil)
}

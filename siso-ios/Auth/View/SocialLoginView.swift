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
    @StateObject private var vm: SocialLoginView.LoginViewModel = .init()
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Image("bgLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Image("vector")
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
                    
                    loginButton(title: "카카오로 계속하기", color: .yellow) {
                        Task {
                            await vm.kakaoLogin()
                        }
                    }
                    loginButton(title: "애플로 계속하기", color: .white) {
                        // Apple Login
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .navigationDestination(isPresented: $vm.isLogined) {
                    AcceptanceView()
                }
            }
        }
    }
    
    // TODO: 로그인 버튼 뷰
    private func loginButton(title: String, color: Color ,action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: 54)
        .background(color)
        .clipShape(.rect(cornerRadius: 99))
        .padding(.vertical, 4.5)
    }
}

#Preview {
    SocialLoginView()
}

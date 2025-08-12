//
//  LoginView.swift
//  auth
//
//  Created by jdios on 8/9/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

public struct SocialLoginView: View {
    @StateObject private var vm: SocialLoginView.LoginViewModel = .init()
    
    public var body: some View {
        VStack {
            Text("카카오 로그인")
            Button("카카오 로그인") {
                Task {
                    await vm.kakaoLogin()
                }
            }
            .buttonStyle(.bordered)
            Button("카카오 로그아웃") {
                Task {
                    await vm.kakaoLogout()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    SocialLoginView()
}

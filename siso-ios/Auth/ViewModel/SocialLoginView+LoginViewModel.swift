//
//  LoginViewModel.swift
//  auth
//
//  Created by jdios on 8/9/25.
//

import SwiftUI

protocol LoginProtocol {
    func kakaoLogin() async
    func kakaoLogout() async
    func AppleLogin() async
    func AppleLogout() async
}

extension SocialLoginView {
    class LoginViewModel: ObservableObject,LoginProtocol {
        func kakaoLogin() async {
            <#code#>
        }
        
        func kakaoLogout() async {
            <#code#>
        }
        
        func AppleLogin() async {
            <#code#>
        }
        
        func AppleLogout() async {
            <#code#>
        }
    }
}

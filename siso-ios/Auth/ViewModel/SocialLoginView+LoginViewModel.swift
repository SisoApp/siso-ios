//
//  LoginViewModel.swift
//  auth
//
//  Created by jdios on 8/9/25.
//

import SwiftUI
import KakaoSDKUser
import network

protocol LoginProtocol {
    func kakaoLogin(completion: @escaping(String) -> Void) async
    func kakaoLogout() async
    func appleLogin() async
    func appleLogout() async
}

public extension SocialLoginView {
    
    @MainActor
    class LoginViewModel: ObservableObject, LoginProtocol {
        
        @Published public var token: String? // accessToken
        @Published public var userState: String = ""
        @Published public var showAlert: Bool = false
        @Published public var alertMessage = ""
        
        let networkManager = LoginNetworkManager()
        
        public init() {}
        
        public func autoLogin() async {
            let result = try? await networkManager.autoLogin()
            // 상태 업데이트
            switch result {
                case .success(let refreshResult):
                    await MainActor.run {
                        self.userState = refreshResult.registrationStatus
                    }
                case .failure(let failure):
                    if failure.responseCode == 401 {
                        alertMessage = "로그인 세션이 만료되었습니다. 다시 로그인 해주세요."
                        showAlert = true
                    }else {
                        alertMessage = "\(String(describing: failure.errorDescription))"
                        showAlert = true
                    }
                    await kakaoLogout()
                case .none:
                    await kakaoLogout()
            }
        }
        
        public func kakaoLogin(completion: @escaping(String) -> Void) async {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                self.token = await innerHavingKaKaoAppLogin()
            } else {
                self.token = await webviewKaKaoLogin()
            }
            
            if let token = self.token {
                do {
                    try await networkManager.login(at: token) { [weak self] state, err in
                        self?.userState = state
                        completion(state)
                        
                        guard let err = err else { return }
                        
                        if let statusCode = err.responseCode {
                            switch statusCode {
                                case 404:
                                    self?.alertMessage = "서버에 문제가 있습니다"
                                    self?.showAlert = true
                                default:
                                    self?.alertMessage = "\(String(describing: err.errorDescription))"
                                    self?.showAlert = true
                            }
                        } else {
                            self?.alertMessage = "\(String(describing: err.errorDescription))"
                            self?.showAlert = true
                        }
                    }
                } catch {
                    print("카카오 로그인 -> 서버로 통신 login 함수 throws err : \(error)")
                }
            }
        }
        
        public func kakaoLogout() async {
            let _ = await logoutKaKao()
            
            await networkManager.logout()
            self.userState = ""
            self.token = nil
        }
        
        func appleLogin() async {
            
        }
        
        func appleLogout() async {
            
        }
    }
}


// MARK: 카카오 로그인 Logic
extension SocialLoginView.LoginViewModel {

    // TODO: 카카오앱이 설치 되어 있을 경우
    private func innerHavingKaKaoAppLogin() async -> String? {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("인앱 카카오 로그인 err: \(error)")
                    continuation.resume(returning: nil)
                } else {
                    print("loginWithKakaoTalk() success.")
                    // 성공 시 동작 구현
                    if let token = oauthToken {
                        continuation.resume(returning: token.accessToken)
                    }
                }
            }
        }
    }
    
    // TODO: 웹뷰로 카카오 로그인
    private func webviewKaKaoLogin() async -> String? {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("웹뷰 카카오 로그인 err: \(error)")
                    continuation.resume(returning: nil)
                } else {
                    print("loginWithKakaoAccount() success.")
                    // 성공 시 동작 구현
                    if let token = oauthToken {
                        continuation.resume(returning: token.accessToken)
                    }
                }
            }
        }
    }
    
    // TODO: 로그아웃 내부 수행 로직
    private func logoutKaKao() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print("kakao logout error: \(error)")
                    continuation.resume(returning: false) // 에러 시 false 반환
                } else {
                    print("kakao logout() success.")
                    continuation.resume(returning: true)
                }
            }
            
        }
    }
}

import SwiftUI
import auth
import network
import Alamofire

/// ** 앱 시작 시 비동기 로직(자동 로그인)을 처리하고 첫 화면을 결정하는 뷰입니다.
public struct InitialView: View {
    // Coordinator와 ViewModel을 EnvironmentObject로 주입받습니다.
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var authVM: SocialLoginView.LoginViewModel

    public init() {}
    
    public var body: some View {
        Group {
            // authVM의 userState 값에 따라 뷰를 분기합니다.
            switch authVM.userState {
                case .login:
                    // 로그인 상태이면 매칭 홈으로 바로 이동합니다.
                    if coordinator.tutorialHasBeenWatched {
                        coordinator.build(IntegrationPage.home)
                    } else {
                        NavigationStack(path: $coordinator.path) {
                            coordinator.build(.tutorial)
                        }
                    }
                case .register:
                    NavigationStack(path: $coordinator.path) {
                        coordinator.build(.accept)
                    }
                case .logout, .undefined:
                    NavigationStack(path: $coordinator.path) {
                        if authVM.userState == .undefined {
                            // 비로그인 상태이거나, 회원가입 플로우가 필요한 경우 로그인 뷰를 보여줍니다.
                            ProgressView()
                        }else {
                            coordinator.build(.login)
                        }
                    }
            }
        }
        .onAppear {
            // 이 뷰가 나타날 때 단 한 번만 자동 로그인을 시도합니다.
            Task {
                await authVM.autoLogin()
            }
        }
        .alert("세션 만료", isPresented: $authVM.showAlert) {
            Button("확인") {
                // 로그인 화면으로 전환
                authVM.userState = .logout
            }
        } message: {
            Text(authVM.alertMessage)
        }
    }
    
    // ** TEST CODE
    func successLogin(state: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("-------- Login Test --------")
            authVM.userState = .login
            print("현재 유저의 상태는 \(authVM.userState)")
            print("----------------------------")
        }
    }
    
    func failedLogin(err: AFError) {
        if err.responseCode == 401 {
            authVM.alertMessage = "로그인 세션이 만료되었습니다. 다시 로그인 해주세요."
            authVM.showAlert = true
        }
        print("현재 유저의 상태는 \(authVM.userState)")
    }
}

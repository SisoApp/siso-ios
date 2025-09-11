
import SwiftUI
import auth
import profile
import matching
import mypage
import chat
import designSystem
import model
import call

public struct AppView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var authVM: SocialLoginView.LoginViewModel
    @EnvironmentObject var callManager: CallManager
    
    public init() {}
    
    public var body: some View {
        Group {
            if authVM.userState == .login {
                MainTabView()
            } else if authVM.userState == .undefined {
                ProgressView()
            } else {
                AuthNavigator()
            }
        }
        .sheet(item: $coordinator.matchingSheet) { sheet in
            coordinator.build(sheet: sheet)
        }
        .sheet(item: $coordinator.profileSheet) { sheet in
            coordinator.build(sheet: sheet)
        }
        .sheet(item: $coordinator.callSheet) { sheet in
            coordinator.build(sheet: sheet)
        }
        .sheet(item: $coordinator.authSheet) { sheet in
            coordinator.build(sheet: sheet)
        }
        .animation(.easeInOut, value: authVM.userState)
        .task {
            if authVM.userState == .undefined {
                await authVM.kakaoLogout()
                await authVM.autoLogin()
            }
        }
        .alert("오류", isPresented: $authVM.showAlert) {
            Button("확인") {
                authVM.userState = .logout
            }
        } message: {
            Text(authVM.alertMessage)
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var callManager: CallManager
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $coordinator.selectedTab) {
                // Matching Tab
                NavigationStack(path: $coordinator.matchingPath) {
                    coordinator.build(appSettings.tutorialHasBeenWatched ? .home : .tutorial)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            coordinator.build(page)
                        }
                }
                .tabItem { Label("둘러보기", systemImage: "house") }.tag(0)
                
                // Chat Tab
                NavigationStack(path: $coordinator.chatPath) {
                    coordinator.build(.main)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            coordinator.build(page)
                        }
                }
                .tabItem { Label("대화", systemImage: "ellipsis.message") }.tag(1)
                
                // MyPage Tab
                NavigationStack(path: $coordinator.myPagePath) {
                    coordinator.build(.my)
                        .navigationDestination(for: IntegrationPage.self) { page in
                            coordinator.build(page)
                        }
                }
                .tabItem { Label("내 정보", systemImage: "person") }.tag(2)
            }
            .tint(Color.Siso.Primary._100)
            
            // ⭐️ 수정: CallManager.shared 대신 주입받은 callManager 사용
            if case .receiving(let payload) = callManager.callState {
                IncommingCallToast(payload: payload)
                // IncommingCallToast도 동일한 callManager를 사용하도록 주입
                    .environmentObject(callManager)
                    .animation(.spring(), value: callManager.callState) // 애니메이션 추가
            }
            VStack {
                Spacer()
                Button {
                    // ⭐️ 수정: CallManager.shared 대신 주입받은 callManager 사용
                    // 현재 상태가 idle일 때만 테스트를 위해 receiving으로 변경
                    if callManager.callState == .idle {
                        callManager.receiveCall(payload: IncomingCallPayload.sample)
                    } else {
                        // 다시 idle 상태로 돌리는 로직 (테스트용)
                        callManager.changeStateForDebug(.idle)
                    }
                } label: {
                    Text(callManager.callState == .idle ? "Show Call Banner" : "Hide Call Banner")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        
    }
}

public struct AuthNavigator: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var authVM: SocialLoginView.LoginViewModel
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if authVM.userState == .register {
                    coordinator.build(.accept)
                } else { // .logout
                    coordinator.build(.login)
                }
            }
            .navigationDestination(for: IntegrationPage.self) { page in
                coordinator.build(page)
            }
        }
    }
}


# 시팅 (Siso) - iOS App                                                                                                                              │ │
│ │                                                                                                                                                      │ │
│ │ > 음성 기반 소셜 매칭 플랫폼                                                                                                                         │ │
│ │                                                                                                                                                      │ │
│ │ 시팅은 음성을 통한 소셜 네트워킹과 실시간 채팅을 제공하는 iOS 애플리케이션입니다. 사용자들이 음성으로 소통하며 새로운 인연을 만들 수 있는 플랫폼을   │ │
│ │ 제공합니다.                                                                                                                                          │ │
확장
message.txt
37KB
일단 이렇게 써주는데 ㅋㅋㅋ
﻿
멘태
cty7574
 
# 시팅 (Siso) - iOS App                                                                                                                              │ │
│ │                                                                                                                                                      │ │
│ │ > 음성 기반 소셜 매칭 플랫폼                                                                                                                         │ │
│ │                                                                                                                                                      │ │
│ │ 시팅은 음성을 통한 소셜 네트워킹과 실시간 채팅을 제공하는 iOS 애플리케이션입니다. 사용자들이 음성으로 소통하며 새로운 인연을 만들 수 있는 플랫폼을   │ │
│ │ 제공합니다.                                                                                                                                          │ │
│ │                                                                                                                                                      │ │
│ │ ## 📱 주요 기능                                                                                                                                      │ │
│ │                                                                                                                                                      │ │
│ │ ### 🎤 음성 기반 매칭                                                                                                                                │ │
│ │ - **실시간 음성 통화**: Agora SDK를 활용한 고품질 음성 통화                                                                                          │ │
│ │ - **매칭 시스템**: 사용자 프로필 기반 스마트 매칭                                                                                                    │ │
│ │ - **음성 프로필**: 사용자의 음성을 활용한 매력적인 프로필 시스템                                                                                     │ │
│ │                                                                                                                                                      │ │
│ │ ### 💬 실시간 채팅                                                                                                                                   │ │
│ │ - **WebSocket 기반**: STOMP 프로토콜을 활용한 실시간 메시징                                                                                          │ │
│ │ - **Combine 아키텍처**: 반응형 프로그래밍으로 구현된 채팅 시스템                                                                                     │ │
│ │ - **옵티미스틱 업데이트**: 즉각적인 사용자 경험                                                                                                      │ │
│ │                                                                                                                                                      │ │
│ │ ### 🔐 소셜 로그인                                                                                                                                   │ │
│ │ - **카카오 로그인**: KakaoSDK를 통한 간편 로그인                                                                                                     │ │
│ │ - **Apple 로그인**: Sign in with Apple 지원                                                                                                          │ │
│ │ - **토큰 관리**: KeyChain을 활용한 안전한 토큰 저장                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ### 📍 위치 기반 서비스                                                                                                                              │ │
│ │ - **위치 정보**: 사용자 위치 기반 매칭 서비스                                                                                                        │ │
│ │ - **프로필 관리**: 관심사, 나이, 지역 등 상세 프로필                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ## 🏗️ 아키텍처                                                                                                                                      │ │
│ │                                                                                                                                                      │ │
│ │ ### 모듈화된 아키텍처                                                                                                                                │ │
│ │ 프로젝트는 Tuist를 활용하여 모듈화된 구조로 설계되었습니다:                                                                                          │ │
│ │                                                                                                                                                      │ │
│ │ ```                                                                                                                                                  │ │
│ │ siso-ios/                                                                                                                                            │ │
│ │ ├── 📱 App (siso-ios)           # 메인 앱 타겟                                                                                                       │ │
│ │ ├── 🔐 Auth                     # 인증 및 로그인 모듈                                                                                                │ │
│ │ ├── 💬 Chat                     # 채팅 기능 모듈                                                                                                     │ │
│ │ ├── 📞 Call                     # 음성 통화 모듈                                                                                                     │ │
│ │ ├── 🎯 Matching                 # 매칭 시스템 모듈                                                                                                   │ │
│ │ ├── 👤 Profile                  # 프로필 관리 모듈                                                                                                   │ │
│ │ ├── 📄 MyPage                   # 마이페이지 모듈                                                                                                    │ │
│ │ ├── 🚨 Notification             # 알림 모듈                                                                                                          │ │
│ │ ├── 🎨 DesignSystem            # 디자인 시스템                                                                                                       │ │
│ │ ├── 🌐 Network                  # 네트워크 레이어                                                                                                    │ │
│ │ ├── 📊 Model                    # 데이터 모델                                                                                                        │ │
│ │ └── 🧭 Coordinator              # 화면 전환 관리                                                                                                     │ │
│ │ ```                                                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ### MVVM + Combine 패턴                                                                                                                              │ │
│ │ - **MVVM 아키텍처**: 명확한 관심사 분리                                                                                                              │ │
│ │ - **Combine Framework**: 반응형 프로그래밍으로 상태 관리                                                                                             │ │
│ │ - **Coordinator Pattern**: 화면 전환과 네비게이션 관리                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ ## 🛠️ 기술 스택                                                                                                                                     │ │
│ │                                                                                                                                                      │ │
│ │ ### Core Technologies                                                                                                                                │ │
│ │ - **iOS 17.0+**: 최신 iOS 기능 활용                                                                                                                  │ │
│ │ - **SwiftUI**: 선언적 UI 프레임워크                                                                                                                  │ │
│ │ - **Combine**: 반응형 프로그래밍                                                                                                                     │ │
│ │ - **Tuist**: 모듈화된 프로젝트 구조                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ### External Dependencies                                                                                                                            │ │
│ │ - **Agora RTC SDK**: 실시간 음성/영상 통신                                                                                                           │ │
│ │ - **Alamofire**: HTTP 네트워킹                                                                                                                       │ │
│ │ - **SwiftStomp**: WebSocket STOMP 프로토콜                                                                                                           │ │
│ │ - **KakaoSDK**: 카카오 소셜 로그인                                                                                                                   │ │
│ │ - **Firebase**: 푸시 알림 및 분석                                                                                                                    │ │
│ │                                                                                                                                                      │ │
│ │ ### Development Tools                                                                                                                                │ │
│ │ - **Xcode 15+**: 개발 환경                                                                                                                           │ │
│ │ - **Tuist**: 프로젝트 생성 및 관리                                                                                                                   │ │
│ │ - **Git**: 버전 관리                                                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ## 🚀 시작하기                                                                                                                                       │ │
│ │                                                                                                                                                      │ │
│ │ ### 필수 요구사항                                                                                                                                    │ │
│ │ - macOS 14.0+                                                                                                                                        │ │
│ │ - Xcode 15.0+                                                                                                                                        │ │
│ │ - iOS 17.0+ (타겟 디바이스)                                                                                                                          │ │
│ │ - [Tuist](https://tuist.io) 설치                                                                                                                     │ │
│ │                                                                                                                                                      │ │
│ │ ### 설치 및 실행                                                                                                                                     │ │
│ │                                                                                                                                                      │ │
│ │ 1. **저장소 클론**                                                                                                                                   │ │
│ │    ```bash                                                                                                                                           │ │
│ │    git clone [repository-url]                                                                                                                        │ │
│ │    cd siso-ios                                                                                                                                       │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ 2. **Tuist 설치** (설치되지 않은 경우)                                                                                                               │ │
│ │    ```bash                                                                                                                                           │ │
│ │    curl -Ls https://install.tuist.io | bash                                                                                                          │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ 3. **의존성 설치**                                                                                                                                   │ │
│ │    ```bash                                                                                                                                           │ │
│ │    tuist install                                                                                                                                     │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ 4. **프로젝트 생성**                                                                                                                                 │ │
│ │    ```bash                                                                                                                                           │ │
│ │    tuist generate                                                                                                                                    │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ 5. **환경 변수 설정**                                                                                                                                │ │
│ │                                                                                                                                                      │ │
│ │    `Configuration/Debug.xcconfig` 파일에 다음 환경 변수들을 설정하세요:                                                                              │ │
│ │    ```                                                                                                                                               │ │
│ │    KAKAO_API_KEY = your_kakao_app_key                                                                                                                │ │
│ │    SERVER_URL = your_server_url                                                                                                                      │ │
│ │    SOKET_URL = your_websocket_url                                                                                                                    │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ 6. **Xcode에서 실행**                                                                                                                                │ │
│ │    ```bash                                                                                                                                           │ │
│ │    open siso-ios.xcworkspace                                                                                                                         │ │
│ │    ```                                                                                                                                               │ │
│ │                                                                                                                                                      │ │
│ │ ### 프로젝트 구조 재생성                                                                                                                             │ │
│ │ ```bash                                                                                                                                              │ │
│ │ # 의존성 업데이트 후 프로젝트 재생성                                                                                                                 │ │
│ │ tuist clean                                                                                                                                          │ │
│ │ tuist install                                                                                                                                        │ │
│ │ tuist generate                                                                                                                                       │ │
│ │ ```                                                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ## 📋 주요 모듈 설명                                                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ### 🔐 Auth Module                                                                                                                                   │ │
│ │ - 카카오/Apple 소셜 로그인                                                                                                                           │ │
│ │ - JWT 토큰 관리 (KeyChain 저장)                                                                                                                      │ │
│ │ - 자동 로그인 및 토큰 갱신                                                                                                                           │ │
│ │                                                                                                                                                      │ │
│ │ ### 💬 Chat Module                                                                                                                                   │ │
│ │ - STOMP WebSocket 기반 실시간 채팅                                                                                                                   │ │
│ │ - Combine을 활용한 반응형 메시지 처리                                                                                                                │ │
│ │ - 옵티미스틱 업데이트로 즉각적인 UI 반응                                                                                                             │ │
│ │                                                                                                                                                      │ │
│ │ ### 📞 Call Module                                                                                                                                   │ │
│ │ - Agora SDK 기반 고품질 음성 통화                                                                                                                    │ │
│ │ - 실시간 매칭 중 음성 통화                                                                                                                           │ │
│ │ - 통화 품질 관리 및 최적화                                                                                                                           │ │
│ │                                                                                                                                                      │ │
│ │ ### 🌐 Network Module                                                                                                                                │ │
│ │ - Alamofire 기반 REST API 통신                                                                                                                       │ │
│ │ - SwiftStomp를 활용한 WebSocket 연결                                                                                                                 │ │
│ │ - 토큰 기반 인증 시스템                                                                                                                              │ │
│ │                                                                                                                                                      │ │
│ │ ## 🎯 핵심 기능 구현                                                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ### 실시간 채팅 시스템                                                                                                                               │ │
│ │ ```swift                                                                                                                                             │ │
│ │ // Combine을 활용한 반응형 메시지 처리                                                                                                               │ │
│ │ class ChatDetailViewModel: ObservableObject {                                                                                                        │ │
│ │     @Published var messages: [ChatMessageResponseDTO] = []                                                                                           │ │
│ │                                                                                                                                                      │ │
│ │     private let sendMessageSubject = PassthroughSubject<(Int, String), Never>()                                                                      │ │
│ │     private let incomingMessageSubject = PassthroughSubject<ChatMessageResponseDTO, Never>()                                                         │ │
│ │                                                                                                                                                      │ │
│ │     // 옵티미스틱 업데이트 + 실시간 동기화                                                                                                           │ │
│ │ }                                                                                                                                                    │ │
│ │ ```                                                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ### 모듈화된 네트워크 계층                                                                                                                           │ │
│ │ ```swift                                                                                                                                             │ │
│ │ // STOMP WebSocket + REST API 통합                                                                                                                   │ │
│ │ public class ChatNetwork {                                                                                                                           │ │
│ │     private var stomp: SwiftStomp?                                                                                                                   │ │
│ │                                                                                                                                                      │ │
│ │     // WebSocket 실시간 메시징                                                                                                                       │ │
│ │     public func connectStomp()                                                                                                                       │ │
│ │     public func messageSend(chatRoomId: Int, content: String)                                                                                        │ │
│ │                                                                                                                                                      │ │
│ │     // REST API 통신                                                                                                                                 │ │
│ │     public func getMessages(chatRoomId: Int) async throws -> [ChatMessageResponseDTO]                                                                │ │
│ │ }                                                                                                                                                    │ │
│ │ ```                                                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ## 🔧 개발 도구 및 설정                                                                                                                              │ │
│ │                                                                                                                                                      │ │
│ │ ### 디버깅 팁                                                                                                                                        │ │
│ │ - **Network Logging**: 모든 API 요청/응답이 콘솔에 로깅됩니다                                                                                        │ │
│ │ - **STOMP Debugging**: WebSocket 연결 상태와 메시지 송수신 로그 확인                                                                                 │ │
│ │ - **Combine Debugging**: 메시지 플로우 추적을 위한 디버그 출력                                                                                       │ │
│ │                                                                                                                                                      │ │
│ │ ### 코드 컨벤션                                                                                                                                      │ │
│ │ - **MVVM Pattern**: ViewModel과 View의 명확한 분리                                                                                                   │ │
│ │ - **Combine Patterns**: Publisher 체인을 통한 데이터 플로우                                                                                          │ │
│ │ - **Modular Architecture**: 각 모듈의 단일 책임 원칙                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ## 📞 지원 및 기여                                                                                                                                   │ │
│ │                                                                                                                                                      │ │
│ │ ### 문제 해결                                                                                                                                        │ │
│ │ - 빌드 오류 시 `tuist clean && tuist generate` 실행                                                                                                  │ │
│ │ - 의존성 문제 시 `tuist install` 재실행                                                                                                              │ │
│ │ - 환경 변수 설정 확인                                                                                                                                │ │
│ │                                                                                                                                                      │ │
│ │ ### 기여 방법                                                                                                                                        │ │
│ │ 1. 이슈 등록 또는 기능 제안                                                                                                                          │ │
│ │ 2. 브랜치 생성 (`feature/your-feature`)                                                                                                              │ │
│ │ 3. 커밋 및 푸시                                                                                                                                      │ │
│ │ 4. Pull Request 생성                                                                                                                                 │ │
│ │                                                                                                                                                      │ │
│ │ ## 📝 라이선스                                                                                                                                       │ │
│ │                                                                                                                                                      │ │
│ │ 이 프로젝트는 [라이선스 명시 필요] 하에 배포됩니다.                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ ---                                                                                                                                                  │ │
│ │                                                                                                                                                      │ │
│ │ **버전**: 1.0.0                                                                                                                                      │ │
│ │ **빌드**: 20250811                                                                                                                                   │ │
│ │ **최소 지원**: iOS 17.0+                                                                                                                             │ │
│ │ **개발 환경**: Xcode 15.0+                            
message.txt
37KB

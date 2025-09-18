# 🎙️ 시팅 (Siso) - iOS App

<p align="center">
  <img src="https://user-images.githubusercontent.com/42947497/188439368-24194165-1250-4849-86a3-2c13084363a7.png" width="200">
</p>
<p align="center">
    <img src="https://img.shields.io/badge/iOS-17.0+-black?logo=apple">
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg">
    <img src="https://img.shields.io/badge/SwiftUI-5-blue.svg">
    <img src="https://img.shields.io/badge/Tuist-3.32.0-green.svg">
    <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg">
</p>

> **음성 기반 소셜 매칭 플랫폼**  
> 시팅은 음성을 통한 소셜 네트워킹과 실시간 채팅을 제공하는 iOS 애플리케이션입니다. 사용자들이 음성으로 소통하며 새로운 인연을 만들 수 있는 플랫폼을 제공합니다.

<br>

## 📚 목차 (Table of Contents)

- [📱 주요 기능](#-주요-기능)
- [🏗️ 아키텍처](#️-아키텍처)
- [🛠️ 기술 스택](#️-기술-스택)
- [🚀 시작하기](#-시작하기)
- [📋 주요 모듈 설명](#-주요-모듈-설명)
- [🎯 핵심 기능 구현](#-핵심-기능-구현)
- [🔧 개발 도구 및 설정](#-개발-도구-및-설정)
- [📞 지원 및 기여](#-지원-및-기여)
- [📝 라이선스](#-라이선스)

---

## 📱 주요 기능

### 🎤 음성 기반 매칭
- **실시간 음성 통화**: Agora SDK를 활용한 고품질 음성 통화
- **매칭 시스템**: 사용자 프로필 기반 스마트 매칭
- **음성 프로필**: 사용자의 음성을 활용한 매력적인 프로필 시스템

### 💬 실시간 채팅
- **WebSocket 기반**: STOMP 프로토콜을 활용한 실시간 메시징
- **Combine 아키텍처**: 반응형 프로그래밍으로 구현된 채팅 시스템
- **옵티미스틱 업데이트**: 즉각적인 사용자 경험

### 🔐 소셜 로그인
- **카카오 로그인**: KakaoSDK를 통한 간편 로그인
- **Apple 로그인**: Sign in with Apple 지원
- **토큰 관리**: KeyChain을 활용한 안전한 토큰 저장

### 📍 위치 기반 서비스
- **위치 정보**: 사용자 위치 기반 매칭 서비스
- **프로필 관리**: 관심사, 나이, 지역 등 상세 프로필

---

## 🏗️ 아키텍처

### 모듈화된 아키텍처
프로젝트는 Tuist를 활용하여 기능별로 명확하게 분리된 모듈 구조로 설계되었습니다.

```
siso-ios/
├── 📱 App (siso-ios)           # 메인 앱 타겟
├── 🔐 Auth                     # 인증 및 로그인 모듈
├── 💬 Chat                     # 채팅 기능 모듈
├── 📞 Call                     # 음성 통화 모듈
├── 🎯 Matching                 # 매칭 시스템 모듈
├── 👤 Profile                  # 프로필 관리 모듈
├── 📄 MyPage                   # 마이페이지 모듈
├── 🚨 Notification             # 알림 모듈
├── 🎨 DesignSystem             # UI 컴포넌트 및 디자인 시스템
├── 🌐 Network                  # 네트워크 레이어
├── 📊 Model                    # 공용 데이터 모델
└── 🧭 Coordinator              # 화면 전환 및 흐름 제어
```

### MVVM + Combine + Coordinator 패턴
- **MVVM 아키텍처**: View, ViewModel, Model의 역할을 명확히 분리하여 테스트 용이성과 유지보수성을 높였습니다.
- **Combine Framework**: 비동기 데이터 스트림을 반응형으로 처리하여 상태 관리를 효율적으로 구현했습니다.
- **Coordinator Pattern**: 화면 전환 로직을 View Controller로부터 분리하여 재사용성을 높이고 의존성을 관리합니다.

---

## 🛠️ 기술 스택

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Core** | `iOS 17.0+` `Swift 5.9` `SwiftUI` `Combine` | 최신 iOS 환경 기반의 선언적 UI 및 반응형 프로그래밍 |
| **Project Management** | `Tuist` | 모듈화된 프로젝트 구조 관리 및 생성 자동화 |
| **Networking** | `Alamofire` `SwiftStomp` | HTTP 통신 및 STOMP 프로토콜 기반 WebSocket 통신 |
| **Real-time Communication**| `Agora RTC SDK` `Firebase Cloud Messaging` | 실시간 음성 통화 및 푸시 알림 |
| **Authentication** | `KakaoSDK` `AuthenticationServices` | 카카오 및 Apple 소셜 로그인 |
| **Development Tools** | `Xcode 15` `Git` | 개발 환경 및 버전 관리 |

---

## 🚀 시작하기

### 필수 요구사항
- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ (타겟 디바이스)
- [Tuist](https://tuist.io) (설치 필요)

### 설치 및 실행
1.  **저장소 클론**
    ```bash
    git clone [repository-url]
    cd siso-ios
    ```

2.  **Tuist 설치** (설치되지 않은 경우)
    ```bash
    curl -Ls https://install.tuist.io | bash
    ```

3.  **의존성 설치**
    ```bash
    tuist install
    ```

4.  **프로젝트 생성**
    ```bash
    tuist generate
    ```

5.  **환경 변수 설정**  
    `Configuration/Secrets.xcconfig` 파일에 다음 환경 변수들을 설정하세요.
    ```
    KAKAO_API_KEY = your_kakao_app_key
    SERVER_URL = your_server_url
    SOKET_URL = your_websocket_url
    ```
    
6.  **Xcode에서 실행**
    `siso-ios.xcworkspace` 파일을 열어 프로젝트를 실행합니다.
    ```bash
    open siso-ios.xcworkspace
    ```

### 프로젝트 구조 재생성
의존성 업데이트 또는 프로젝트 설정 변경 후 아래 명령어를 실행하세요.
```bash
tuist clean && tuist install && tuist generate
```

---

## 📋 주요 모듈 설명

| Module | Description |
| :--- | :--- |
| **🔐 Auth** | 카카오/Apple 소셜 로그인, JWT 토큰 관리(KeyChain), 자동 로그인 및 토큰 갱신 |
| **💬 Chat** | STOMP WebSocket 기반 실시간 채팅, Combine을 활용한 반응형 메시지 처리, 옵티미스틱 UI |
| **📞 Call** | Agora SDK 기반 고품질 음성 통화, 실시간 매칭 중 통화 연결, 통화 품질 관리 |
| **🌐 Network**| Alamofire 기반 REST API 클라이언트, SwiftStomp를 활용한 WebSocket 연결 관리, 토큰 기반 인증 |

---

## 🎯 핵심 기능 구현

### 실시간 채팅 시스템
`Combine`과 `PassthroughSubject`를 활용하여 메시지 송수신 및 옵티미스틱 업데이트를 반응형으로 처리합니다.

```swift
// Combine을 활용한 반응형 메시지 처리
class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessageResponseDTO] = []

    private let sendMessageSubject = PassthroughSubject<(Int, String), Never>()
    private let incomingMessageSubject = PassthroughSubject<ChatMessageResponseDTO, Never>()

    // 옵티미스틱 업데이트 + 실시간 동기화 로직 구현
}
```

### 모듈화된 네트워크 계층
`Network` 모듈에서 REST API와 WebSocket 통신을 통합하여 관리합니다.

```swift
// STOMP WebSocket + REST API 통합
public class ChatNetwork {
    private var stomp: SwiftStomp?

    // WebSocket 실시간 메시징
    public func connectStomp()
    public func messageSend(chatRoomId: Int, content: String)

    // REST API 통신
    public func getMessages(chatRoomId: Int) async throws -> [ChatMessageResponseDTO]
}
```

---

## 🔧 개발 도구 및 설정

### 디버깅 팁
- **Network Logging**: 모든 API 요청/응답이 콘솔에 로깅됩니다.
- **STOMP Debugging**: WebSocket 연결 상태와 메시지 송수신 로그를 확인합니다.
- **Combine Debugging**: `print()`, `breakpoint()` 오퍼레이터를 사용하여 데이터 플로우를 추적합니다.

### 코드 컨벤션
- **MVVM Pattern**: ViewModel과 View의 명확한 분리를 지향합니다.
- **Combine Patterns**: Publisher 체인을 통한 선언적 데이터 플로우를 구성합니다.
- **Modular Architecture**: 각 모듈의 단일 책임 원칙(SRP)을 준수합니다.

---

## 📞 지원 및 기여

### 문제 해결
- 빌드 오류 시: `tuist clean && tuist generate` 실행
- 의존성 문제 시: `tuist install` 재실행
- 실행 오류 시: `Configuration/Secrets.xcconfig` 환경 변수 설정 확인

### 기여 방법
1.  이슈 등록 또는 기능 제안
2.  브랜치 생성 (`feature/your-feature`)
3.  커밋 및 푸시
4.  Pull Request 생성

---

## 📝 라이선스
이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참고해주세요.

---

**Version**: 1.0.0  
**Build**: 20250811  
**Minimum Target**: iOS 17.0+

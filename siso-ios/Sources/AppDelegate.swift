import UIKit
import call
import UserNotifications // 푸시 알림을 위한 프레임워크
import FirebaseCore
import FirebaseMessaging
import model
import network
// SwiftUI 앱에 연결되기 위해 NSObject와 UIApplicationDelegate를 상속받습니다.
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - 1. 앱 시작 시 초기 설정
    
    /// 앱이 처음 시작될 때 호출되는 메서드입니다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // UNUserNotificationCenter의 delegate를 self(AppDelegate)로 설정합니다.
        // 이렇게 해야 포그라운드 알림 수신 등 푸시 관련 콜백을 이 파일에서 받을 수 있습니다.
        UNUserNotificationCenter.current().delegate = self
        
        // 앱 시작 시 사용자에게 푸시 알림 권한을 요청합니다.
        requestNotificationAuthorization()
        
        // 원격 알림(푸시)을 받기 위해 앱을 등록합니다.
        // 이 코드가 실행되면 iOS 시스템은 APNs에 이 기기를 등록하고, 성공 시 Device Token을 반환합니다.
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        return true
    }
    
    // MARK: - 2. APNs 등록 및 Device Token 처리
    
    /// `registerForRemoteNotifications()`가 성공하여 APNs로부터 Device Token을 받았을 때 호출됩니다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Device Token은 Data 형태로 전달됩니다. 서버로 보내기 위해 16진수 문자열로 변환합니다.
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        // print("✅ APNs Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
        // 🚨 중요: 이 tokenString을 사용자의 ID와 함께 백엔드 서버로 전송해야 합니다.
        // 예: ApiClient.shared.sendDeviceToken(token: tokenString)
        // 백엔드는 이 토큰을 저장해두었다가, 해당 사용자에게 푸시를 보낼 때 사용합니다.
    }
    
    /// Device Token 등록에 실패했을 때 호출됩니다.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🛑 Failed to register for remote notifications: \(error.localizedDescription)")
        
        // 시뮬레이터에서는 항상 실패합니다. 실제 기기에서 테스트해야 합니다.
    }
    
    // MARK: - 3. 원격 알림(푸시) 수신 처리
    
    /// **가장 중요한 부분입니다.**
    /// 앱이 실행 중이거나 백그라운드에 있을 때 원격 알림을 받으면 이 메서드가 호출됩니다.
    /// (앱이 완전히 종료된 상태에서 푸시를 탭하여 실행된 경우는 didFinishLaunchingWithOptions에서 처리할 수도 있습니다)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("📨 Received remote notification: \(userInfo)")
        
        // 여기서 받은 userInfo 딕셔너리가 백엔드에서 보낸 JSON 페이로드입니다.
        // 이 데이터를 파싱하여 CallManager에 전달합니다.
        handlePushNotification(userInfo: userInfo)
        
        // 시스템에 데이터 처리가 끝났음을 알립니다.
        // 새로운 데이터를 가져왔으므로 .newData를 전달합니다.
        completionHandler(.newData)
    }
    
    // MARK: - 4. 푸시 데이터 처리 및 CallManager 호출
    
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        
        // 1. [AnyHashable: Any]를 JSON 데이터로 변환
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: []) else {
            print("🔴 Push Handler: userInfo를 JSON 데이터로 변환 실패")
            return
        }

        do {
            // 2. JSON 데이터를 IncomingCallPayload 모델로 디코딩
            let decoder = JSONDecoder()
            let payload = try decoder.decode(IncomingCallPayload.self, from: jsonData)
            
            // 3. 타입 확인 및 분기 처리
            if payload.type == "CALL" {
                print("✅ Push Handler: 통화 알림 수신. CallManager에 전달합니다.")
                // ✅ CallManager의 메서드에 디코딩된 'payload' 객체 전체를 전달!
                CallManager.shared.handleIncomingCall(with: payload)
            } else {
                // "MESSAGE" 타입 등 다른 푸시 처리
                print("ℹ️ Push Handler: 일반 메시지 알림 수신.")
            }

        } catch {
            print("🔴 Push Handler: 푸시 페이로드 디코딩 실패. Error: \(error)")
        }
    }
}
// MARK: - UNUserNotificationCenterDelegate 구현

extension AppDelegate {
    
    /// **앱이 포그라운드(화면 맨 앞에 활성화) 상태일 때** 알림이 도착하면 호출됩니다.
    /// 이 메서드를 구현하지 않으면, 포그라운드 상태에서는 푸시 알림이 사용자에게 보이지 않습니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("📨 Received notification in foreground: \(userInfo)")
        
        // 여기서도 동일하게 통화 정보를 처리해줍니다.
        // `didReceiveRemoteNotification`이 호출되지 않는 iOS 버전이나 상황을 대비하여 중복으로 처리해주는 것이 안전합니다.
        handlePushNotification(userInfo: userInfo)
        
        // 포그라운드에서 전화 수신 UI가 바로 뜨기 때문에, 시스템 알림(배너, 소리)은 보여주지 않도록 빈 배열을 전달합니다.
        // 만약 일반 알림이라면 [.banner, .sound, .badge] 등을 전달하여 알림을 표시할 수 있습니다.
        completionHandler([])
    }

    /// 사용자가 알림 배너를 탭하거나, 알림 센터에서 알림을 선택했을 때 호출됩니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("👆 User tapped notification: \(userInfo)")
        
        // 사용자가 알림을 탭한 경우에도 통화 정보를 처리합니다.
        handlePushNotification(userInfo: userInfo)
        
        completionHandler()
    }
}

// MARK: - ✨ Firebase Messaging Delegate Extension ✨
// FCM 토큰 관리 관련 델리게이트
extension AppDelegate: MessagingDelegate {
    
    /// FCM 등록 토큰이 갱신될 때마다 호출되는 메서드입니다.
    /// - 토큰은 앱 재설치, 사용자 데이터 삭제, 앱 업데이트 시 등 다양한 경우에 갱신될 수 있습니다.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            print("🔴 FCM token is nil.")
            return
        }
        KeyChainManager.shared.save(token: token, for: "fcmToken")
        print("🔥 FCM Registration Token: \(token)")
        
        // 2. 현재 로그인한 사용자의 ID가 키체인에 있는지 확인합니다.
               if let userIdString = KeyChainManager.shared.get(for: "myUserId"),
                  let userId = Int(userIdString) {
                   
                   // 3. 로그인 상태라면, 즉시 서버로 갱신된 토큰을 전송합니다.
                   Task {
                       do {
                           let dto = FcmTokenRequestDto(userId: userId, token: token)
                           try await NetworkManager.shared.registerFcmToken(dto: dto)
                           print("✅ AppDelegate: 갱신된 FCM 토큰을 서버에 성공적으로 전송했습니다.")
                       } catch {
                           print("🔴 AppDelegate: 갱신된 FCM 토큰을 서버에 전송하는 데 실패했습니다: \(error)")
                       }
                   }
               } else {
                   // 4. 비로그인 상태라면, 토큰을 저장만 해두고 넘어갑니다.
                   //    (나중에 로그인 성공 시 LoginNetworkManager가 전송해 줄 것입니다.)
                   print("ℹ️ 비로그인 상태이므로, FCM 토큰 서버 전송은 다음 로그인 시 진행됩니다.")
               }
    }
   
}


// MARK: - Helper Methods Extension
private extension AppDelegate {
    
    /// 사용자에게 알림 권한을 요청하는 함수
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
            
            if granted {
                print("✅ Notification authorization granted.")
            } else {
                print("❌ Notification authorization denied.")
            }
        }
    }
}

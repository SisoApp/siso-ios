import UIKit
import call
import UserNotifications // 푸시 알림을 위한 프레임워크
import FirebaseCore
// SwiftUI 앱에 연결되기 위해 NSObject와 UIApplicationDelegate를 상속받습니다.
class AppDelegate: NSObject, UIApplicationDelegate {

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
        return true
    }

    // MARK: - 2. APNs 등록 및 Device Token 처리
    
    /// `registerForRemoteNotifications()`가 성공하여 APNs로부터 Device Token을 받았을 때 호출됩니다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Device Token은 Data 형태로 전달됩니다. 서버로 보내기 위해 16진수 문자열로 변환합니다.
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ APNs Device Token: \(tokenString)")
        
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
        handleIncomingCall(userInfo: userInfo)
        
        // 시스템에 데이터 처리가 끝났음을 알립니다.
        // 새로운 데이터를 가져왔으므로 .newData를 전달합니다.
        completionHandler(.newData)
    }

    // MARK: - 4. 푸시 데이터 처리 및 CallManager 호출
    
    /// userInfo 딕셔너리를 파싱하여 CallManager의 상태를 업데이트하는 헬퍼 함수입니다.
    private func handleIncomingCall(userInfo: [AnyHashable: Any]) {
        // 백엔드에서 약속한 "call_info" 키가 있는지, 그리고 그 값이 딕셔너리 형태인지 확인합니다.
        guard let callInfo = userInfo["call_info"] as? [String: Any],
              // 딕셔너리 안에서 필요한 값들을 타입에 맞게 추출합니다.
              let channelId = callInfo["channel_id"] as? String,
              let token = callInfo["rtc_token"] as? String,
              let callerName = callInfo["caller_name"] as? String else {
            // "call_info"가 없거나 내부 형식이 다르면, 일반 알림이거나 잘못된 푸시이므로 무시합니다.
            print("푸시 페이로드에 통화 정보가 없거나 형식이 올바르지 않습니다.")
            return
        }
        
        // 모든 정보가 정상적으로 파싱되었다면, CallManager 싱글톤 인스턴스를 통해
        // 전화가 왔음을 알립니다. 이 함수 호출 하나로 SwiftUI 뷰가 반응하게 됩니다.
        
    }
}

// MARK: - UNUserNotificationCenterDelegate 구현

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// **앱이 포그라운드(화면 맨 앞에 활성화) 상태일 때** 알림이 도착하면 호출됩니다.
    /// 이 메서드를 구현하지 않으면, 포그라운드 상태에서는 푸시 알림이 사용자에게 보이지 않습니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("📨 Received notification in foreground: \(userInfo)")
        
        // 여기서도 동일하게 통화 정보를 처리해줍니다.
        // `didReceiveRemoteNotification`이 호출되지 않는 iOS 버전이나 상황을 대비하여 중복으로 처리해주는 것이 안전합니다.
        handleIncomingCall(userInfo: userInfo)
        
        // 포그라운드에서 전화 수신 UI가 바로 뜨기 때문에, 시스템 알림(배너, 소리)은 보여주지 않도록 빈 배열을 전달합니다.
        // 만약 일반 알림이라면 [.banner, .sound, .badge] 등을 전달하여 알림을 표시할 수 있습니다.
        completionHandler([])
    }

    /// 사용자가 알림 배너를 탭하거나, 알림 센터에서 알림을 선택했을 때 호출됩니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("👆 User tapped notification: \(userInfo)")
        
        // 사용자가 알림을 탭한 경우에도 통화 정보를 처리합니다.
        handleIncomingCall(userInfo: userInfo)
        
        completionHandler()
    }
}


// MARK: - Helper Methods

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
                // 사용자에게 설정에서 알림을 켜달라고 유도하는 UI를 보여주는 것이 좋습니다.
            }
        }
    }
}

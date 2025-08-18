import SwiftUI
import Combine // Timer.publish를 사용하기 위해 필요

struct CountdownView: View {
    // 1. 타이머의 남은 시간을 초 단위로 관리할 @State 변수
    // 8분 = 8 * 60 = 480초
    @State private var remainingSeconds = 480
    
    // 2. 1초마다 이벤트를 방출(publish)하는 타이머 생성
    // .main 스레드에서 실행하여 UI 업데이트를 안전하게 함
    // .common 모드는 사용자가 스크롤하는 중에도 타이머가 계속 작동하게 함
    // .autoconnect()는 뷰가 나타나면 자동으로 타이머를 시작시킴
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("남은 통화시간 \(timeString(from: remainingSeconds))")
            .font(.system(size: 20, weight: .semibold, design: .monospaced)) // monospaced 폰트는 숫자가 바뀔 때 텍스트가 흔들리지 않게 해줍니다.
            .onReceive(timer) { _ in
                // 3. 타이머가 이벤트를 방출할 때마다 이 코드가 실행됨
                if remainingSeconds > 0 {
                    // 남은 시간이 0보다 크면 1초씩 감소
                    remainingSeconds -= 1
                } else {
                    // 4. 남은 시간이 0이 되면 타이머를 멈춤
                    timer.upstream.connect().cancel()
                }
            }
    }
    
    // 5. 남은 초(Int)를 "MM:SS" 형태의 문자열(String)으로 변환하는 함수
    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        // String(format:)을 사용하여 항상 두 자리 숫자로 표시 (예: 08, 01)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    CountdownView()
}

import Foundation
import AVFoundation

// SwiftUI 뷰와 함께 사용하기 위해 ObservableObject를 채택
public class AudioPlayerManager: ObservableObject {
    
    
    // AVPlayer는 오디오/비디오 재생을 위한 핵심 객체입니다.
    private var player: AVPlayer?
    
    // 재생 상태를 UI에 바인딩하기 위한 @Published 프로퍼티
    @Published var isPlaying: Bool = false
    
    // 오디오 재생이 끝났는지 확인하기 위한 Observer
    private var timeObserver: Any?
    
    // ✨ 현재 재생 중인 파일의 URL을 저장할 프로퍼티 추가
    @Published var currentlyPlayingURL: URL? = nil
    
    
    public init() {
        // 앱이 백그라운드에서도 오디오를 재생할 수 있도록 오디오 세션을 설정합니다.
        // (선택 사항이지만 대부분의 오디오 앱에 필요)
        setupAudioSession()
    }
    
    deinit {
        // 객체가 메모리에서 해제될 때 옵저버를 제거하여 메모리 누수를 방지합니다.
        removeTimeObserver()
    }
    
    /// URL로부터 오디오를 재생합니다.
    /// - Parameter url: 재생할 오디오 파일의 URL
    func play(from url: URL) {
        // 이전에 재생 중이던 항목이 있다면 정지합니다.
        stop()
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // 오디오 재생이 끝나는 시점을 감지하기 위한 옵저버를 추가합니다.
        addTimeObserver()
        
        player?.play()
        isPlaying = true
        
        currentlyPlayingURL = url
        print("▶️ 오디오 재생 시작: \(url.absoluteString)")
    }
    
    /// 현재 재생 중인 오디오를 일시정지합니다.
    func pause() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
        print("⏸️ 오디오 일시정지")
    }
    
    /// 현재 재생 중인 오디오를 다시 시작합니다.
    func resume() {
        guard let player = player else { return }
        player.play()
        isPlaying = true
        print("▶️ 오디오 다시 시작")
    }
    
    /// 오디오 재생을 완전히 멈추고 처음으로 되돌립니다.
    func stop() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: .zero) // 재생 위치를 0으로 이동
        isPlaying = false
        removeTimeObserver() // 기존 옵저버 제거
        self.player = nil // 플레이어 인스턴스 해제
        
        // ✨ 정지 시 URL도 nil로 초기화
               currentlyPlayingURL = nil
        print("⏹️ 오디오 정지")
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ 오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }
    
    private func addTimeObserver() {
        // NotificationCenter를 사용하여 AVPlayerItem이 끝까지 재생되었을 때 알림을 받습니다.
        guard let currentItem = player?.currentItem else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: currentItem
        )
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        // 오디오가 끝나면 isPlaying 상태를 false로 변경합니다.
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentlyPlayingURL = nil // ✨ 재생 완료 시 URL 초기화
            print("✅ 오디오 재생 완료")
            // 필요하다면 여기서 stop()을 호출하여 리소스를 완전히 정리할 수 있습니다.
            // self.stop()
        }
    }
    
    private func removeTimeObserver() {
        // NotificationCenter에서 옵저버를 안전하게 제거합니다.
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

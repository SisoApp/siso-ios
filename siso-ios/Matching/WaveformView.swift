import SwiftUI

struct WaveformView: View {
    private let randomFactors: [(offset: Double, speed: Double)]
    private let count: Int
    
    var height: CGFloat
    @Binding var isPlaying: Bool

    init(count: Int, height: CGFloat, isPlaying: Binding<Bool>) {
        self.count = count
        self.randomFactors = (0..<count).map { _ in
            (offset: Double.random(in: 0...(.pi * 2)),
             speed: Double.random(in: 0.5...1.5))
        }
        self._isPlaying = isPlaying
        self.height = height
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.016)) { timeline in
            HStack(spacing: 4) {
                ForEach(0..<count, id: \.self) { index in
                    // --- 오류 해결 부분 ---
                    // 로직을 ForEach 내부, View를 반환하기 전에 계산합니다.
                    // 이렇게 하면 각 반복마다 heightRatio가 계산되고 바로 View에서 사용됩니다.
                    let heightRatio: CGFloat = {
                        if isPlaying {
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let factor = randomFactors[index]
                            let sinValue = sin(now * factor.speed + factor.offset)
                            return (sinValue + 1) / 2
                        } else {
                            return 0.01
                        }
                    }() // 클로저를 정의하고 바로 실행하여 값을 할당

                    Rectangle()
                        .fill(Color.purple)
                        .frame(height: height * heightRatio)
                        .cornerRadius(4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: isPlaying)
        }
        .frame(height: height)
    }
}

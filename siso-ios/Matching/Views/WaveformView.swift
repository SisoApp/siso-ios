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
                    
                    let heightRatio: CGFloat = {
                        if isPlaying {
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let factor = randomFactors[index]
                            let sinValue = sin(now * factor.speed + factor.offset)
                            return (sinValue + 1) / 2
                        } else {
                            return 0.1
                        }
                    }() // 클로저를 정의하고 바로 실행하여 값을 할당

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 3, height: height * heightRatio)
                        .cornerRadius(4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: isPlaying)
        }
        .frame(height: height)
    }
}

struct CallingWaveformView: View {
    private let randomFactors: [(offset: Double, speed: Double)]
    private let count: Int
    
    var isplaying: Bool
    var height: CGFloat
    
    let colors: [Color] = [.Siso.Orange._10, .Siso.Orange._20, .Siso.Orange._30, .Siso.Orange._40, .Siso.Orange._50]
    

    init(count: Int, height: CGFloat, isplaying: Bool) {
        self.count = count
        self.randomFactors = (0..<count).map { _ in
            (offset: Double.random(in: 0...(.pi * 2)),
             speed: Double.random(in: 0.5...1.5))
        }
        self.isplaying = isplaying
        self.height = height
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.016)) { timeline in
            HStack(spacing: 10) {
                ForEach(0..<count, id: \.self) { index in
                    
                    let heightRatio: CGFloat = {
                        if isplaying {
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let factor = randomFactors[index]
                            let sinValue = sin(now * factor.speed + factor.offset)
                            return (sinValue + 1) / 2
                        } else {
                            return 0.1
                        }
                    }() // 클로저를 정의하고 바로 실행하여 값을 할당

                    Rectangle()
                        .fill(colors[index % colors.count])
                        .frame(height: height * heightRatio)
                        .cornerRadius(4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: isplaying)
        }
        .frame(height: height)
    }
}

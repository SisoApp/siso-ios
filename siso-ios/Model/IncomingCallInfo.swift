import Foundation

public struct IncomingCallInfo: Identifiable {
    public init(channelId: String, token: String, opponentProfile: MatchingProfile) {
        self.channelId = channelId
        self.token = token
        self.opponentProfile = opponentProfile
    }
    public let id: UUID = UUID()
    public let channelId: String
    public let token: String
    public let opponentProfile: MatchingProfile // 상대방 정보
}


// MARK: - Sample Data

public extension IncomingCallInfo {
    /// SwiftUI 프리뷰 또는 테스트용으로 사용할 샘플 데이터입니다.
    /// UserProfileServer에 정의된 `sampleMessi` 데이터를 사용합니다.
    static var sample: IncomingCallInfo {
        IncomingCallInfo(
            channelId: "sample_channel_messi_10",
            token: "007eJ...valid...agora...token...for...testing",
            
            // 제공해주신 UserProfileServer.sampleMessi를 직접 사용합니다.
            // 이제 통화 정보와 프로필 정보가 일관성을 가지게 됩니다.
            opponentProfile: MatchingProfile.sampleMessi
        )
    }
}

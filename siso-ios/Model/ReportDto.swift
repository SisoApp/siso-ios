//
//  ReportResponseDto.swift
//  network
//
//  Created by jdios on 9/4/25.
//

import Foundation


/// 신고 등록 성공 시 응답으로 받는 DTO (`ReportResponseDto`)
public struct ReportResponseDto: Decodable {
    public let id: Int
    public let reporterId: Int
    public let reportedId: Int
    public let reportTitle: String
    public let description: String
    public let createdAt: String // 서버의 LocalDateTime은 보통 String으로 받습니다.
    public let reportType: ServerReportType
}
/// 신고 등록 요청 시 Body에 담길 DTO (`ReportRequestDto`)
public struct ReportRequestDto: Encodable {
    public let reportedId: Int
    public let reportTitle: String
    public let description: String
    public let reportType: ServerReportType
    
    public init(reportedId: Int, reportTitle: String, description: String, reportType: ServerReportType) {
        self.reportedId = reportedId
        self.reportTitle = reportTitle
        self.description = description
        self.reportType = reportType
    }
}
/// 서버의 ReportType Enum과 일치하는 Swift Enum
public enum ServerReportType: String, Codable, CaseIterable, Identifiable {
    
    case SPAM = "스팸/광고"
    case INAPPROPRIATE = "부적절한 언행 (욕설, 음란, 폭력)"
    case HARASSMENT = "괴롭힘/혐오 발언"
    case IMPERSONATION = "사칭 의심 (본인 아님 / 프로필과 다름)"
    case ILLEGAL_CONTENT = "불법 콘텐츠 (마약, 불법광고 등)"
    case SEXUAL_CONTENT = "성적인 콘텐츠 (성희롱, 음란물)"
    case VIOLENCE = "폭력적인 행위"
    case PRIVACY = "개인정보 침해 혹은 탈취 시도"
    case OTHER = "기타"
    
    // ForEach에서 id로 사용될 값
    public var id: Self { self }
    
    // 화면에 표시될 텍스트 (rawValue를 그대로 사용)
    public var displayText: String {
        return self.rawValue
    }
    
    
}

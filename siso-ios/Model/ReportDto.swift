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
    
    case SPAM = "SPAM"
    case INAPPROPRIATE = "INAPPROPRIATE"
    case HARASSMENT = "HARASSMENT"
    case IMPERSONATION = "IMPERSONATION"
    case ILLEGAL_CONTENT = "ILLEGAL_CONTENT"
    case SEXUAL_CONTENT = "SEXUAL_CONTENT"
    case VIOLENCE = "VIOLENCE"
    case PRIVACY = "PRIVACY"
    case OTHER = "OTHER"
    
    // ForEach에서 id로 사용될 값
    public var id: Self { self }
    
    // 화면에 표시될 텍스트 (rawValue를 그대로 사용)
    public var displayText: String {
        return self.rawValue
    }
    
    
}

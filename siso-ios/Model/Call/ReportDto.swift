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
  
    public var displayText: String {
           switch self {
           case .IMPERSONATION:
                      return "사칭 의심 (본인아님 / 프로필과 본인이 다름)"
                  case .INAPPROPRIATE:
                      return "부적절한 언행 (욕설·음란·폭력)"
                  case .SPAM:
                      return "스팸/광고"
                  case .HARASSMENT:
                      return "괴롭힘/혐오 발언"
                  case .ILLEGAL_CONTENT:
                      return "불법 콘텐츠 (마약·불법광고 등)"
                  case .PRIVACY:
                      return "개인정보 유출"
                  case .OTHER:
                      return "기타 (직접작성)"
                      
                  // --- 이미지에는 없지만 Enum에 존재하는 케이스들 ---
                  case .SEXUAL_CONTENT:
                      // '부적절한 언행'의 '음란' 항목을 좀 더 구체화한 표현
                      return "성적인 콘텐츠 또는 성희롱"
                  case .VIOLENCE:
                      // '부적절한 언행'의 '폭력' 항목을 좀 더 구체화한 표현
                      return "폭력적이거나 위협적인 행위"
           }
       }
    
}

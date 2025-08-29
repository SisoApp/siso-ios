// 자료형 확장을 여기 폴더에 작성합니다.
// 이 파일은 확장 기능의 소개를 위한 것입니다.
// 각 자료형에 대한 확장은 해당 자료형의 파일에 작성합니다.
// 예: String 확장은 String+Extensions.swift 파일에 작성합니다.
import Foundation

public extension Date {
    // Date Format Convert String
    public static func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

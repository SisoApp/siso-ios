//
//  String+Extension.swift
//  designSystem
//
//  Created by 멘태 on 9/18/25.
//
import SwiftUI

public extension String {
    // 채팅 목록에서 표시할 시간
    func getChatListTime() -> String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let date: Date = formatter.date(from: self) else { return "" }
        
        let calendar = Calendar.current
        let now: Date = .init()
        
        // 오늘 날짜일 때 ex) 오전 10:41
        if calendar.isDate(date, inSameDayAs: now) {
            formatter.dateFormat = "a h:mm"
            return formatter.string(from: date)
        }
        
        // 어제일 때 ex) 어제
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
            calendar.isDate(date, inSameDayAs: yesterday) {
            return "어제"
        }
        
        // 그 이전은 날짜만 표시 ex) 9월 18일
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
    
    // 메시지에 함께 표시할 시간
    func getMessageTime() -> String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let date: Date = formatter.date(from: self) else { print("nil"); return "" }
        
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
}

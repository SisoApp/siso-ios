//
//  MeetingProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import Foundation

class MeetingProfileViewModel {
    let  meetings: [String] = [
        "##동호회활동👥", "##봉사활동🤝", "#취미모임🎯", "#문화생활🎭", "#함께운동🏋️‍♂️", "#산책동행🚶‍♀️", "#맛집탐방🍽️", "#차한잔☕️",
        "#여행동행🌍", "#사진동행📷", "#골프동반⛳️", "#영화동행🎞️", "#콘서트동행🎤", "#전시회동행🖼️", "#등산메이트🥾", "#자전거메이트🚴‍♂️",
        "#독서모임📖", "#토크모임💬", "#취향공유💌", "#새로운인연🌟", "#소통해요📱", "#함께하는시간⏳", "#좋은사람과함께😊", "#인연만들기💞"
    ]
    
    func chucked(into size: Int) -> [[String]] {
        return stride(from: 0, to: meetings.count, by: size).map {
            Array(meetings[$0..<min($0 + size, meetings.count)])
        }
    }
}

//
//  ChatMainView.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//
import SwiftUI
import designSystem




public struct ChatMainView: View {
    @State private var selectedList: ContactType = .recentChat
    
    // 삭제 기능을 위해 상태 변수로 관리합니다.
    @State private var callHistory: [Contact] = []
    @State private var recentChats: [RecentChat] = []
    
    public init() {}
    
    public var body: some View {
        VStack {
            List {
                switch selectedList {
                case .callList:
                    ForEach(callHistory) { contact in
                        ContactView(userName: contact.userName, icon: contact.icon, time: formatTime(date: contact.time), type: .callList)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    print("delete!!")
                                } label: {
                                    Text("인연 끊기")
                                        .fontWeight(.semibold)
                                }
                            }
                    }
                case .recentChat:
                    ForEach(recentChats) { contact in
                        ContactView(userName: contact.userName, icon: contact.icon, time: formatTime(date: contact.time), type: .recentChat, hasMessage: contact.hasMessages, recentMessage: contact.recentMessage)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                print("나가기")
                            } label: {
                                Text("나가기")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(.clear)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            selectedList = .callList
                        }
                    }, label: {
                        Text("전화 내역")
                            .foregroundStyle(selectedList == .callList ? .black : Color.Siso.Gray._50)
                    })
                    Button(action: {
                        withAnimation {
                            selectedList = .recentChat
                        }
                    }, label: {
                        Text("최근 채팅")
                            .foregroundStyle(selectedList == .recentChat ? .black : Color.Siso.Gray._50)
                    })
                }
                .font(.system(size: 24, weight: .bold))
                .lineSpacing(7.2)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "bell")
            }
        }
        .onAppear {
            // View가 나타날 때 초기 데이터를 State 변수에 로드합니다.
            self.recentChats = chats
            self.callHistory = calls
        }
    }
    
    // Date Format Convert String
    private func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}


// TODO: Type Define
public extension ChatMainView {
    struct Contact: Identifiable {
        public let id: UUID = UUID()
        let userName: String
        let icon: String
        let time: Date
    }

    struct RecentChat: Identifiable {
        public let id: UUID = UUID()
        let userName: String
        let icon: String
        let time: Date
        let hasMessages: Bool
        let recentMessage: String = "닉네임닉네임님과의 채팅방이 개설되었습니다."
        
        public init(userName: String, icon: String, time: Date, hasMessages: Bool) {
            self.userName = userName
            self.icon = icon
            self.time = time
            self.hasMessages = hasMessages
        }
    }
    
    enum ContactType {
        case callList
        case recentChat
    }
}

// TODO: 더미데이터를 별도의 구조체로 분리하여 관리합니다.
public extension ChatMainView {
    var calls: [Contact] {
        [
            Contact(userName: "김철수", icon: "person.circle.fill", time: Date().addingTimeInterval(-300)),
            Contact(userName: "이영희", icon: "person.circle.fill", time: Date().addingTimeInterval(-1200)),
            Contact(userName: "박지성", icon: "person.circle.fill", time: Date().addingTimeInterval(-3600)),
            Contact(userName: "최유리", icon: "person.circle.fill", time: Date().addingTimeInterval(-86400)),
            Contact(userName: "정다빈", icon: "person.circle.fill", time: Date().addingTimeInterval(-172800))
        ]
    }
    
    var chats: [RecentChat] {
        [
            RecentChat(userName: "세종대왕", icon: "person.circle.fill", time: Date().addingTimeInterval(-9000), hasMessages: true),
            RecentChat(userName: "이순신", icon: "person.circle.fill", time: Date().addingTimeInterval(-2500), hasMessages: true),
            RecentChat(userName: "안중근", icon: "person.circle.fill", time: Date().addingTimeInterval(-500), hasMessages: false),
            RecentChat(userName: "김구", icon: "person.circle.fill", time: Date().addingTimeInterval(-95000), hasMessages: false),
            RecentChat(userName: "허준", icon: "person.circle.fill", time: Date().addingTimeInterval(-200000), hasMessages: false)
        ]
    }
}


#Preview {
    NavigationStack {
        ChatMainView()
    }
}

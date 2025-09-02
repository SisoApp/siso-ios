//
//  ChatMainView.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//
import SwiftUI
import designSystem




public struct ChatMainView: View {
    @State private var selectedList: ContactType = .callList
    
    // 삭제 기능을 위해 상태 변수로 관리합니다.
    @State private var callHistory: [Contact] = []
    @State private var recentChats: [RecentChat] = []
    var delegate: ChatCoordinatorDelegate?
    
    public init(delegate: ChatCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
                switch selectedList {
                case .callList:
                    if callHistory.isEmpty {
                        Image("smartphone")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("첫 전화를 기다리고 있어요.\n 마음 맞는 분께 목소리로 인사해보세요.")
                            .font(.system(size: 20))
                            .lineLimit(10)
                            .tracking(-0.01)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                            .foregroundStyle(Color.Siso.Gray._70)
                    }else {
                        List {
                            ForEach(callHistory) { contact in
                                ContactView(contact: contact, type: selectedList, delegate: delegate)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            print("delete!!")
                                        } label: {
                                            Text("인연 끊기")
                                                .fontWeight(.semibold)
                                        }
                                        .tint(Color.Siso.Red._60)
                                    }
                            }
                        }
                        .listStyle(.plain)
                        .background(.clear)
                        
                    }
                case .recentChat:
                    if recentChats.isEmpty {
                        Image("coffeecup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("아직 대화한 기록이 없어요.\n 좋은 인연과 이야기를 나눠보세요.")
                            .font(.system(size: 20))
                            .lineLimit(10)
                            .tracking(-0.01)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                            .foregroundStyle(Color.Siso.Gray._70)
                    }else {
                        List {
                            ForEach(recentChats) { chat in
                                ContactView(chat: chat, type: selectedList, delegate: delegate)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        print("나가기")
                                    } label: {
                                        Text("나가기")
                                            .fontWeight(.semibold)
                                    }
                                    .tint(Color.Siso.Red._60)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .background(.clear)
                    }
                }
            
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
                    .onTapGesture {
                        delegate?.pushChat(.notificationChat)
                    }
            }
        }
        .onAppear {
            // View가 나타날 때 초기 데이터를 State 변수에 로드합니다.
            self.recentChats = chats
            self.callHistory = calls
        }
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

//
//#Preview {
//    NavigationStack {
//        ChatMainView()
//    }
//}

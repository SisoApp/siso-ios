//
//  MyPageView.swift
//  auth
//
//  Created by 멘태 on 8/19/25.
//

import SwiftUI
import designSystem

enum MyPageInfo: String, CaseIterable, Identifiable {
    case call = "통화 기록"
    case blacklist = "차단 / 신고한 인연"
    case filter = "매칭 필터 설정"
    
    var id: String { self.rawValue }
}

struct MyPageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                profileBox()
                profileProgressView()
                userInfoList()
                
                Spacer()
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
            .navigationTitle("내 정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingButton()
                }
            }
        }
    }
    
    private func profileBox() -> some View {
        return HStack {
            VStack {
                Image("testimg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(.rect(cornerRadius: 60))
                    .overlay {
                        Circle()
                            .rotation(.degrees(270))
                            .trim(from: 0, to: 0.36)
                            .stroke(
                                Color.Siso.Primary.main,
                                style: StrokeStyle(
                                    lineWidth: 8,
                                    lineCap: .round
                                )
                            )
                    }
            }
            
            VStack {
                Text("삼성전자회장이나야")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("28세")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Siso.Gray._50)
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Label {
                    Text("서울 중구")
                        .font(.system(size: 18))
                } icon: {
                    Image("location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 8)
    }
    
    private func profileProgressView() -> some View {
        return HStack(spacing: 12) {
            Text("36% 완성")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            Color.Siso.Primary._50,
                            style: StrokeStyle(lineWidth: 3)
                        )
                        .background(.clear)
                }
                .background(.white)
            
            Button {
                
            } label: {
                HStack {
                    Text("자기소개 완성하기")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Image("pencil_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundStyle(.black)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                SpeechBubble()
                    .fill(Color.Siso.Primary.main)
            )

        }
        .padding(.horizontal)
        .offset(y: -20)
    }
    
    private func userInfoList() -> some View {
        return Group {
            Text("계정 정보")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.top, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List(MyPageInfo.allCases, id: \.self) { item in
                Text(item.rawValue)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        switch item {
                        case .call:
                            break
                        case .blacklist:
                            break
                        case .filter:
                            break
                        }
                    }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
    
    private func settingButton() -> some View {
        return Button {
            
        } label: {
            Image("gear")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
}

struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 16
        let tailWidth: CGFloat = 16
        let tailHeight: CGFloat = 10
        let bubbleRect = CGRect(
            x: rect.minX + tailWidth,
            y: rect.minY,
            width: rect.width - tailWidth,
            height: rect.height
        )
        
        // 본체
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // 꼬리
        let midY = bubbleRect.midY
        path.move(to: CGPoint(x: bubbleRect.minX, y: midY - tailHeight))
        path.addLine(to: CGPoint(x: rect.minX, y: midY))
        path.addLine(to: CGPoint(x: bubbleRect.minX, y: midY + tailHeight))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    MyPageView()
}

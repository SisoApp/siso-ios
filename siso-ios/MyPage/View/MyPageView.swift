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
                userInfoList()
                
                Spacer()
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
            .navigationTitle("내 정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    private func profileBox() -> some View {
        return HStack {
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
            
            VStack {
                Text("삼성전자회장이나야")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("28세")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Siso.Gray._70)
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
    
    private func userInfoList() -> some View {
        return Group {
            Text("계정 정보")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.top, 30)
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
}

#Preview {
    MyPageView()
}

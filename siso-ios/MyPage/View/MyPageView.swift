//
//  MyPageView.swift
//  auth
//
//  Created by 멘태 on 8/19/25.
//

import SwiftUI
import designSystem
import model

enum MyPageInfo: String, CaseIterable, Identifiable {
    case blacklist = "차단 / 신고한 인연"
    case filter = "매칭 필터 설정"
    
    var id: String { self.rawValue }
}

public struct MyPageView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject private var viewModel: MyPageViewModel = .init()
    
    weak var delegate: MyPageCoordinatorDelegate?
    
    public init(delegate: MyPageCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
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
        .task {
            await viewModel.getMyProfile()
        }
    }
    
    private func profileBox() -> some View {
        return HStack {
            profileImageView()
            
            VStack(spacing: 4) {
                if let profile = viewModel.profile {
                    Text(profile.nickname)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(profile.age.description + "세")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                locationView()
            }
            .padding(.leading)
        }
        .padding(.horizontal, 8)
    }
    
    private func profileImageView() -> some View {
        return Group {
            if let image = viewModel.images?[0],
               let imageUrl = URL(string: image.presignedUrl) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        
                } placeholder: {
                    Image("Camera")
                        .resizable()
                        .scaledToFit()
                        .padding(32)
                }
            } else {
                Image("Camera")
                    .resizable()
                    .scaledToFit()
                    .padding(32)
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(.rect(cornerRadius: 60))
        .overlay {
            Circle()
                .rotation(.degrees(270))
                .trim(from: 0, to: (Double(viewModel.progress) / 100))
                .stroke(
                    Color.Siso.Primary.main,
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
        }
    }
    
    private func locationView() -> some View {
        return Group {
            if let profile = viewModel.profile,
               let location = profile.location, !location.isEmpty {
                Label {
                    Text(location)
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
    }
    
    private func profileProgressView() -> some View {
        return HStack(spacing: 12) {
            Text("\(viewModel.progress)% 완성")
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
            
            profileButton()
        }
        .padding(.horizontal)
        .offset(y: -20)
    }
    
    private func profileButton() -> some View {
        return Button {
            delegate?.pushMyPageToProfile()
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
        .padding(.leading)
        .foregroundStyle(.black)
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .background(
            SpeechBubble()
                .fill(Color.Siso.Primary.main)
        )
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
            delegate?.pushMyPage(.setting)
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
    MyPageView(delegate: nil)
}

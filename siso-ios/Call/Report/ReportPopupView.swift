//
//  SuePopupView.swift
//  auth
//
//  Created by jdios on 8/24/25.
//

import SwiftUI
import model


enum ReportReasonType: String, CaseIterable, Identifiable {
    case impersonation = "사칭 의심 (본인 아님 / 프로필과 다름)"
    case inappropriate = "부적절한 언행 (욕설, 음란, 폭력)"
    case spam = "스팸/광고"
    case harassment = "괴롭힘/혐오 발언"
    case illegalContent = "불법 콘텐츠 (마약, 불법광고 등)"
    case privacy = "개인정보 유출"
    case other = "기타"
    
    // ForEach에서 id로 사용될 값
    var id: Self { self }
    
    // 화면에 표시될 텍스트 (rawValue를 그대로 사용)
    var displayText: String {
        return self.rawValue
    }
}

public struct ReportPopupView: View {
    @State private var otherSueReason: String = ""
    @State private var selectedType: ReportReasonType? = nil
    
    
    var opponentProfile: CallInfoDto
    
    public init(opponentProfile: CallInfoDto) {
        self.opponentProfile = opponentProfile
    }
    
   public var body: some View {
        headerView
        profileImageView(profile: opponentProfile)
        
        radioButtons
        if selectedType == .other {
            TextEditor(text: $otherSueReason)
                .frame(width: .infinity, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.Siso.Gray._30)
                )
                .padding()
            
        }
        
        Button {
            print("sue")
        } label: {
            Text("신고하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(Color.Siso.Primary._50)
                )
                .padding()
        }

        
    }
    private var headerView: some View {
        Text("\(opponentProfile.nickname)님을\n아래 사유로 신고합니다.")
            .font(.system(size: 20, weight: .semibold))
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func profileImageView(profile: CallInfoDto) -> some View {
        // profileImageUrls가 비어있을 경우를 대비
        if profile.profileImageUrl == nil {
            placeholderImage
        } else {
            let urlString = profile.profileImageUrl ?? "https://imgur.com/a/24214AF"
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(.circle)
                    .frame(width: 120 ,height: 120)
            } placeholder: {
                
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                
            }
        }
    }
    
    /// 이미지가 없을 때 표시할 플레이스홀더
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            )
    }
    
    private var radioButtons: some View {
        VStack(alignment: .leading) {
            // UI 목록은 ReportReasonType으로 생성
            ForEach(ReportReasonType.allCases) { reasonType in
                Button(action: { self.selectedType = reasonType }) {
                    HStack {
                        Image(systemName: self.selectedType == reasonType ? "largecircle.fill.circle" : "circle")
                            
                        Text(reasonType.displayText)
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .foregroundStyle(.black)
                    .padding()
                }
            }
            
            
           
        }
    }
}

//
//  SuePopupView.swift
//  auth
//  Created by jdios on 8/24/25.
//

import SwiftUI
import model
import network

public struct ReportPopupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var reportComplete: Bool = false
    @State private var otherReportReason: String = ""
    @State private var selectedType: ServerReportType? = nil
    
    
    var opponentProfile: MatchingProfile
    var onComplete: (() -> Void)?
    
    public init(opponentProfile: MatchingProfile) {
        self.opponentProfile = opponentProfile
    }
    
    public var body: some View {
        headerView
        profileImageView(profile: opponentProfile)
        
        radioButtons
        if selectedType == .OTHER {
            TextEditor(text: $otherReportReason)
                .frame(width: .infinity, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.Siso.Gray._30)
                )
                .padding()
            
        }
        
        Button {
            // 리포트 제거 후 디스미스 되어야함
            Task {
                
                await submitReport()
                dismiss()
            }
            
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
    private func profileImageView(profile: MatchingProfile) -> some View {
        // profileImageUrls가 비어있을 경우를 대비
        if profile.imageUrls.first == nil {
            placeholderImage
        } else {
            let urlString = profile.imageUrls.first ?? "https://imgur.com/a/24214AF"
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
            ForEach(ServerReportType.allCases) { reasonType in
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
    
    /// 신고 내용을 서버에 전송하는 비동기 함수
    private func submitReport() async {
        guard let selectedType = selectedType else {
            print("🚨 신고 사유를 선택해주세요.")
            // TODO: 사용자에게 알림 표시
            return
        }
        
        // title과 description을 description 프로퍼티로 통일
        let reportTitle = selectedType.displayText
        let description = (selectedType == .OTHER) ? otherReportReason : selectedType.displayText
        
        // 서버로 보낼 DTO 생성 (변환 함수 없이 selectedType을 직접 사용)
        let reportDto = ReportRequestDto(
            reportedId: opponentProfile.userId,
            reportTitle: reportTitle,
            description: description,
            reportType: selectedType // ✅ 변환 없이 바로 사용!
        )
        
        do {
            let response = try await NetworkManager.shared.addReport(dto: reportDto)
            print("✅ 신고 성공: \(response)")
            await MainActor.run {
                withAnimation {
                                   reportComplete = true
                               }
            }
        } catch {
            print("🔴 신고 실패: \(error.localizedDescription)")
            // TODO: 사용자에게 실패 알림 표시
        }
    }
}


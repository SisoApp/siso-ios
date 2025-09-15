//
//  IncommingCallToast.swift
//  call
//
//  Created by jdios on 9/9/25.
//

import SwiftUI
import model

public struct IncommingCallToast: View {
  
    @EnvironmentObject var callManager: CallManager
    let payload: IncomingCallPayload
    
    
    public init(payload: IncomingCallPayload) {
        self.payload = payload
    }
    
    public var body: some View {
        VStack {
            HStack {
                profileImageView
                
                Text("\(payload.callerName)님으로부터\n전화가 걸려왔어요.")
                Spacer()
            }
            actionButtonSection
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .shadow(radius: 5)
        }
    }
    @ViewBuilder
    private var profileImageView: some View {
        let urlString = payload.callerImage
        
        // URL 문자열이 유효한지 확인
        if let url = URL(string: urlString) {
            
            // AsyncImage의 phase를 사용하여 로딩 상태를 세밀하게 제어
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    // 로딩 중일 때 ProgressView 표시
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                    
                case .success(let image):
                    // 로딩 성공 시 이미지 표시
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                case .failure:
                    // 로딩 실패 시 플레이스홀더 표시
                    placeholderImage
                    
                @unknown default:
                    // 미래를 위한 대비
                    EmptyView()
                }
            }
            
        } else {
            // URL 자체가 없을 경우 플레이스홀더 표시
            placeholderImage
        }
    }
    /// 이미지가 없거나 로딩 실패 시 표시할 플레이스홀더
    private var placeholderImage: some View {
        // 시스템 아이콘을 사용하여 더 깔끔한 플레이스홀더 제공
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.gray.opacity(0.3)) // 좀 더 연한 회색으로
            .clipShape(Circle())
    }
    
    private var actionButtonSection: some View {
        HStack {
            Button {
                Task{
                    await callManager.denyCall()
                }
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .foregroundStyle(Color.Siso.Red._60)
                    Image("quitcallicon")
                         .padding()
                }
            }
            
            
            Button {
                Task {
                    await callManager.acceptCall()

                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .foregroundStyle(Color.Siso.Green._60)
                    Image("phoneicon")
                        .padding()
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .padding(.horizontal)
        
    }
}

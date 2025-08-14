//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI
import designSystem

public struct ImageProfileView: View {
    var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 3,
                title: "나를 표현하는 사진을 보여주세요",
                subTitle: "최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
            )
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.2))
                
                VStack {
                    Image("Camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                    
                    Text("(0/5)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }
            .frame(height: 206)
            .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
            
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.2))
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.2))
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.2))
            }
            .frame(height: 106)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
            Spacer()
            
            Button("사진 추가하기") {
                delegate?.pushProfile(.introduce)
            }
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .foregroundStyle(.black)
            .clipShape(.rect(cornerRadius: 27))
            .padding()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        delegate?.pop()
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImageProfileView(delegate: nil)
    }
}

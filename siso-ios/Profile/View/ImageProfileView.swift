//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI

public struct ImageProfileView: View {
    var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        ProfileHeaderView(
            currentPage: 3,
            title: "나를 표현하는 사진을 보여주세요",
            subTitle: "최소 1개 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
        )
        
        RoundedRectangle(cornerRadius: 24)
            .fill(.gray.opacity(0.2))
            .frame(height: 206)
            .padding(.vertical, 32)
            .padding(.horizontal)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
            }
        
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
}

#Preview {
    ImageProfileView(delegate: nil)
}

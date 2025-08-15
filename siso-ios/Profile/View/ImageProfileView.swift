//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI
import designSystem

public struct ImageProfileView: View {
    @State private var selectedImages: [Image] = []
    
    var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 3,
                title: "나를 표현하는 사진을 보여주세요",
                subTitle: "최소 1장 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
            )
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Siso.Gray._20)
                
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
            .padding(EdgeInsets(top: 36, leading: 16, bottom: 0, trailing: 16))
            
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Siso.Gray._20)
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Siso.Gray._20)
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Siso.Gray._20)
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Siso.Gray._20)
            }
            .frame(height: 72)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
            Spacer()
            
            nextButton()
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
    
    private func nextButton() -> some View {
        let isActive: Bool = selectedImages.count > 0
        
        return Button {
            if isActive {
                delegate?.pushProfile(.introduce)
            } else {
                delegate?.presentProfile(sheet: .imageHelper({ images in
                    self.selectedImages = images
                    print(images)
                }))
            }
        } label: {
            Text(isActive ? "계속하기" : "사진 추가하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            Color.Siso.Primary._80,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ImageProfileView(delegate: nil)
    }
}

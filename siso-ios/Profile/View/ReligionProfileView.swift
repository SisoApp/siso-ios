//
//  ReligionProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum Religion: String, Identifiable, CaseIterable {
    case christianity = "기독교"
    case catholic = "천주교"
    case buddhism = "불교"
    case wonBuddhism = "원불교"
    case none = "무교"
    case other = "기타/(직접입력)"
    
    var id: String { rawValue }
}

public struct ReligionProfileView: View {
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("종교가 있나요?")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            firstButtonStack()
                .padding(.top, 24)
                .padding(.bottom, 4)
            
            secondButtonStack()
            
            Spacer()
            
            completeButton()
        }
        .padding()
        .navigationTitle("내 정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
    
    private func firstButtonStack() -> some View {
        let religions = Religion.allCases.prefix(Religion.allCases.count / 2)
        
        return HStack(spacing: 12) {
            ForEach(religions) { religion in
                Button {
                    
                } label: {
                    Text(religion.rawValue)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._90)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Siso.Gray._20)
                )
                .frame(height: 48)
            }
        }
    }
    
    private func secondButtonStack() -> some View {
        let religions = Religion.allCases.suffix(Religion.allCases.count / 2)
        
        return HStack(spacing: 12) {
            ForEach(religions) { religion in
                Button {
                    
                } label: {
                    Text(religion.rawValue)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._90)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Siso.Gray._20)
                )
                .frame(height: 48)
            }
        }
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            delegate?.pushProfile(.interest)
        } label: {
            Text("완료하기")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .frame(height: 54)
        .padding(.bottom, 38)
    }
}

#Preview {
    NavigationStack {
        ReligionProfileView(delegate: nil)
    }
}

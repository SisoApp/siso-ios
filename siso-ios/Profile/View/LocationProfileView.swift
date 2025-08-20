//
//  LocationProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct LocationProfileView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("어디에 거주하시나요?")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Text("검색")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Siso.Gray._50)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._20)
            )
            .frame(height: 54)
            .padding(.top, 24)
            
            HStack() {
                Image("gps")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("현재 위치로 설정하기")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.Siso.Gray._50)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LocationProfileView()
}

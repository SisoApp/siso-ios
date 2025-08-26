//
//  LocationProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct LocationProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @ObservedObject var viewModel: LocationViewModel
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile, viewModel: LocationViewModel) {
        self.delegate = delegate
        self.userProfile = userProfile
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            indicatorView()
            
            VStack {
                locationView()
                completeButton()
            }
            .navigationTitle("내 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color.Siso.Gray._50)
                        .onTapGesture {
                            delegate?.pop()
                        }
                }
            }
        }
    }
    
    private func indicatorView() -> some View {
        return Group {
            if viewModel.isLoading {
                SimpleSpinner()
            }
        }
    }
    
    private func locationView() -> some View {
        return VStack {
            Text("어디에 거주하시나요?")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                delegate?.presentProfile(sheet: .location)
            } label: {
                Text(viewModel.location.isEmpty ? "검색" : viewModel.location)
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
                    .onTapGesture {
                        viewModel.getLocation()
                    }
                
                Spacer()
            }
            .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
            
            Spacer()
        }
        .padding()
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = !viewModel.location.isEmpty && !viewModel.isLoading
        
        return Button {
            userProfile.location = viewModel.location
            delegate?.pop()
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
        .padding(.horizontal)
    }
}

struct SimpleSpinner: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.Siso.Gray._50, lineWidth: 3)
            .frame(width: 30, height: 30)
            .rotationEffect(Angle(degrees: isRotating))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isRotating = 360
                }
            }
    }
}

#Preview {
    LocationProfileView(delegate: nil, userProfile: .empty, viewModel: .init())
}

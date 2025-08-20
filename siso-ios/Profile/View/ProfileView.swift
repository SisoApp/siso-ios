//
//  ProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct ProfileView: View {
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var introduce: String = ""
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                Image("testimg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .clipShape(.rect(cornerRadius: 60))
                    .padding(.top, 10)
                
                nicknameView()
                ageView()
                introduceView()
                
                Spacer()
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
    }
    
    private func nicknameView() -> some View {
        return Group {
            Text("닉네임")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $nickname)
                .font(.system(size: 24, weight: .bold))
                .padding()
                .frame(height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Siso.Gray._20)
                )
        }
    }
    
    private func ageView() -> some View {
        return Group {
            Text("나이")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextField("", text: $age)
                    .padding()
                    .frame(width: 86, height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.Siso.Gray._20)
                    )
                Text("세")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.Siso.Gray._50)
                Spacer()
            }
        }
    }
    
    private func introduceView() -> some View {
        return Group {
            Text("자기소개")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._60)
                    .padding(.trailing, 8)
                    .frame(height: 44)
                
                Image("pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.top)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._20)
                    
                    .frame(height: 195)
                
                TextEditor(text: $introduce)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(introduce.count)/50")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.Siso.Gray._50)
                    }
                }
                .padding()
            }
            .padding(.top)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(delegate: nil)
    }
}

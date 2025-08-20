//
//  NotificationView.swift
//  mypage
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel = NotificationViewModel()
    weak var delegate: MyPageCoordinatorDelegate?
    
    public init(delegate: MyPageCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        settingList()
            .padding(.top, 24)
            .padding(.horizontal)
            .navigationTitle("알림")
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
    
    private func settingList() -> some View {
        return List(NotificationSetting.allCases, id: \.self) { item in
            HStack {
                Text(item.rawValue)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        
                    }
                
                Spacer()
                
                Toggle("",
                       isOn: Binding(get: { viewModel.agreements[item] ?? false },
                                     set: { viewModel.agreements[item] = $0 })
                )
                .labelsHidden()
                .tint(Color.Siso.Primary._50)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        NotificationView(delegate: nil)
    }
}

//
//  LocationProfileSheet.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum Province: String, Identifiable, CaseIterable {
    case seoul = "서울"
    case gyeonggi = "경기"
    case incheon = "인천"
    case busan = "부산"
    case gyeongbuk = "경북"
    case gyeongnam = "경남"
    case daegu = "대구"
    case chungbuk = "충북"
    case chungnam = "충남"
    case daejeon = "대전"
    case gwangju = "광주"
    case ulsan = "울산"
    case jeonnam = "전남"
    case jeonbuk = "전북"
    case jeju = "제주"
    case gangwon = "강원"
    case sejong = "세종"
    
    var id: String { rawValue }
}

public struct LocationProfileSheet: View {
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        sheet()
            .presentationDetents([.height(500)])
            .presentationCornerRadius(24)
    }
    
    private func sheet() -> some View {
        return VStack {
            HStack {
                Spacer()
                
                Text("지역선택")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .bold()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        delegate?.dismissProfileSheet()
                    }
            }
            .padding()
            
            provinceList()
                .padding(.trailing)
        }
    }
    
    private func provinceList() -> some View {
        return List(Province.allCases, id: \.self) { item in
            Text(item.rawValue)
                .font(.system(size: 18))
                .padding(.vertical, 8)
                .onTapGesture {
                    
                }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    LocationProfileSheet(delegate: nil)
}

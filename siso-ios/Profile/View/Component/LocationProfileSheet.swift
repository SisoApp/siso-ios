//
//  LocationProfileSheet.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI



public struct LocationProfileSheet: View {
    @ObservedObject private var viewModel: LocationViewModel
    @State private var isShow: Bool = false
    @State private var province: Province = .seoul
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, viewModel: LocationViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    public var body: some View {
        sheet()
            .presentationDetents([.height(500)])
            .presentationCornerRadius(24)
    }
    
    private func sheet() -> some View {
        return Group {
            if isShow {
                cityView()
            } else {
                provinceView()
            }
        }
    }
    
    private func provinceView() -> some View {
        return VStack {
            HStack {
                Spacer().frame(width: 24)
                
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
                    viewModel.location = item.rawValue
                    province = item
                    isShow = true
                }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func cityView() -> some View {
        return VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .bold()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        isShow = false 
                    }
                
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
            
            cityList()
                .padding(.trailing)
        }
    }
    
    private func cityList() -> some View {
        let cities: [String] = viewModel.getCities(province)
        
        return List(cities, id: \.self) { city in
            Text(city)
                .font(.system(size: 18))
                .padding(.vertical, 8)
                .onTapGesture {
                    viewModel.location += " \(city)"
                    delegate?.dismissProfileSheet()
                }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    LocationProfileSheet(delegate: nil, viewModel: .init())
}

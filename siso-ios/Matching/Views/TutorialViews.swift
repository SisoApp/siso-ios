//
//  DimmedView.swift
//  matching
//
//  Created by jdios on 8/11/25.
//

import SwiftUI
import designSystem

struct TutorialViews: View {
    @State var selectedTabIndex: Int = 0
    var body: some View {
        ZStack {
          
                TabView(selection: $selectedTabIndex) {
                    TutorialView1()
                        .tag(0)
                    TutorialView2()
                        .tag(1)
                    TutorialView3()
                        .tag(2)
                }
                .tabViewStyle(.page)
            VStack {
                Spacer()
                
                VStack{
                    Button {
                        selectedTabIndex += 1
                    } label: {
                        Text("계속하기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(Color.Siso.Primary._40)
                            )
                    }
                    
                    Button {
                        print("Jump to main")
                    } label: {
                        Text("건너뛰기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.Siso.Gray._50)
                            .padding()
                        
                    }
                }
                .padding()
                .background(.white)
                

            }
        }
    }
}

public struct TutorialView1: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image ("guide01")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

public struct TutorialView2: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image ("guide02")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            Spacer()
        }
       
    }
}

public struct TutorialView3: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image ("guide03")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

#Preview(body: {
    TutorialViews()
})

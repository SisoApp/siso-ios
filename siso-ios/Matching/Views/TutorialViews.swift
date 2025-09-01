//
//  DimmedView.swift
//  matching
//
//  Created by jdios on 8/11/25.
//

import SwiftUI
import designSystem
import model

public struct TutorialViews: View {
    @State public var selectedTabIndex: Int = 0
    public var delegate: MatchingCoordinatorDelegate
    @EnvironmentObject var appSettings: AppSettings
    public init(selectedTabIndex: Int = 0, delegate: MatchingCoordinatorDelegate) {
        self.selectedTabIndex = selectedTabIndex
        self.delegate = delegate
    }
    public var body: some View {
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
                        if selectedTabIndex == 2 {
                            appSettings.tutorialHasBeenWatched = true
                            delegate.pushMatching(.home)
                            delegate.pushMatching(.home)
                            
                            
                        } else {
                            selectedTabIndex += 1
                        }
                       
                    } label: {
                        let text = selectedTabIndex == 2 ? "시작하기" : "다음으로"
                        Text(text)
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
                        appSettings.tutorialHasBeenWatched = true
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

//
//  SocialView.swift
//  siso-ios
//
//  Created by 김용해 on 8/11/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

public struct SocialView: View {
    public var delegate: AuthCoordinatorDelegate?
    
    public init(delegate: AuthCoordinatorDelegate?) {
        self.delegate = delegate
        
        if let bundle = Bundle(identifier: "io.tuist.siso-ios.auth") {
            if let apiKey = bundle.infoDictionary?["KAKAO_API_KEY"] as? String {
                KakaoSDK.initSDK(appKey: apiKey)
            }
        } else {
            print("API Key not found")
        }
    }
    
    public var body: some View {
        SocialLoginView()
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
    }
}

#Preview {
    SocialLoginView()
}

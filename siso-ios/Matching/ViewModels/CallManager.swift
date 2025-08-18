//
//  CallManager.swift
//  siso-ios
//
//  Created by jdios on 8/16/25.
//


import SwiftUI

public class CallManager: ObservableObject {
    public static let shared = CallManager()
    public weak var delegate: MatchingCoordinatorDelegate?
    public init( isMuteMode: Bool = false, isSpeakerMode: Bool = false) {
        self.isMuteMode = isMuteMode
        self.isSpeakerMode = isSpeakerMode
    }

    @Published var isMuteMode = false
    {
        willSet {
            if newValue == true {
                muteOn()
            } else {
                muteOff()
            }
        }
    }
    @Published var isSpeakerMode = false
    {
        willSet {
            if newValue == true {
                speakerModeOn()
            } else {
                speakerModeOff()
            }
        }
    }
    func startCall() {
        print("start Call")
        delegate?.pushCallingView()
    }
    
    func quitCall() {
        print("quit Call")
        
         delegate?.popToRoot()
        
        delegate?.pushCallInteruptPopup()
    }

    func speakerModeOn() {
        print("speakerPhoneMode")
        
    }
    
    func speakerModeOff() {
        print("speakerPhoneModeOff")
    }
    
    func muteOn() {
        print("MuteModeOn")
    }
    
    func muteOff() {
        print("MuteModeOff")
    }
    
    
}

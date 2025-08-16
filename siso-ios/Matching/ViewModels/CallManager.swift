//
//  CallManager.swift
//  siso-ios
//
//  Created by jdios on 8/16/25.
//


import SwiftUI

final class CallManager: ObservableObject {
    @Published var isCalling = false {
        willSet {
            if newValue == true {
                quitCall()
            }
        }
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
    
    func quitCall() {
        print("quit Call")
        isCalling = true
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

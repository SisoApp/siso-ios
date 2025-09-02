//
//  InterestProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 9/1/25.
//

import Foundation
import model

public extension InterestProfileView {
    class InterestProfileViewModel {
        var interestOptions: [(String, [(String, String)])] {
            return ProfileOptions.getInterestOptions()
        }
    }
}

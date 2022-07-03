//
//  FloatingPointExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 04/07/22.
//

import Foundation


extension FloatingPoint {
    func rounded(to value: Self,
                 roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
        (self / value).rounded(roundingRule) * value
    }
}

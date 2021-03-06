//
//  Comparable+Clamping.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}

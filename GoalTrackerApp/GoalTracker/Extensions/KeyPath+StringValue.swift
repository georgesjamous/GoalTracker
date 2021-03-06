//
//  KeyPath+StringValue.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

extension KeyPath where Root: NSObject {
    var stringValue: String {
        NSExpression(forKeyPath: self).keyPath
    }
}

//
//  QueueHierarchy.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation

/// This will allow us to split the subsystems into seperate queue lanes.
/// We dont want a system/repo/class to exessively use the queue and prevent other
/// work from being done.
extension DispatchQueue {
    static let tracker = DispatchQueue(label: "com.domain.tracker", qos: .default)
    static let persistence = DispatchQueue(label: "com.domain.persistence", qos: .default)
    static let repository = DispatchQueue(label: "com.domain.repository", qos: .default)
}

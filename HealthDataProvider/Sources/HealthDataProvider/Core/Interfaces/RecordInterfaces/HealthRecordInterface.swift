//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// Represents a single HealthRecord
public protocol HealthRecordInterface {
    var id: UUID { get }
    var date: Date { get }
}

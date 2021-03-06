//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

public struct RunningDistanceHealthRecord: RunningDistanceHealthRecordInterface {
    public let id: UUID
    public let date: Date
    public var distanceInMeters: Int
}

//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

public struct WalkingDistanceHealthRecord: WalkingDistanceHealthRecordInterface {
    public let id: UUID
    public let date: Date
    public var distanceInMeters: Int
}

//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

public struct StepHealthRecord: StepHealthRecordInterface {
    public let id: UUID
    public let date: Date
    public let stepCount: Int
}

//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

public protocol RunningDistanceHealthDataProviding: HealthDataProviding {
    
    var recordPublisher: AnyPublisher<RunningDistanceHealthRecordInterface, Never> { get }
    
}

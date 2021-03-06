//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

public protocol WalkingDistanceHealthDataProviding: HealthDataProviding {
    
    var recordPublisher: AnyPublisher<WalkingDistanceHealthRecordInterface, Never> { get }
    
}

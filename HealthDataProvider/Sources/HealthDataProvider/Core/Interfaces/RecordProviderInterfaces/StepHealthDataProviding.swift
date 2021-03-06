//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

public protocol StepHealthDataProviding: HealthDataProviding {
    
    var recordPublisher: AnyPublisher<StepHealthRecordInterface, Never> { get }
    
}

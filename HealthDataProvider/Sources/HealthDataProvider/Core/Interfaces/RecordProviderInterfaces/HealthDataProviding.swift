//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// HealthDataProviding provies health data for a specific Date (Day)
public protocol HealthDataProviding {
    
    init(startDate: Date, endDate: Date)
    
    func startLoadingRecords()
    
    func stopLoadingRecords()
    
}

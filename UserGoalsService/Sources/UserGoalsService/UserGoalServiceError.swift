//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import ApiCall

public enum UserGoalServiceError: Error {
    
    // case businessError1
    // case businessError2
    
    // the api error underneeth
    case network(ApiError)
    
}

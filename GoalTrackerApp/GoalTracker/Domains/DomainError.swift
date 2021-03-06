//
//  DomainError.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import ApiCall
import UserGoalsService

/// Note:
/// Domain error represent the commonerrors that we use in the app.
/// This wraps the business and network errors, so that we only import the different libraries everywhere.
/// This gives us an abstraction over other error types.
enum DomainError: Error {
    
    case noNetwork
    
    // any other error type
    case error(Error)
        
    init(_ apiError: ApiError) {
        switch apiError {
        case .timeout:
            self = .noNetwork
        default:
            self = .error(apiError)
        }
    }
    
    init(_ apiError: UserGoalServiceError) {
        switch apiError {
        case .network(let apiError):
            self = DomainError(apiError)
        }
    }
    
}

extension DomainError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "No network connection"
        case .error(let error):
            return ""
        }
    }
    var failureReason: String? {
        switch self {
        case .noNetwork:
            return "Please make sure that you are connected to the internet"
        default:
            return ""
        }
    }
}

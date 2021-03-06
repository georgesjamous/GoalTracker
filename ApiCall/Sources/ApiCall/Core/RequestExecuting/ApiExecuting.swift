//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// Abstract APi executing protocol that can be expanded.
/// This can be implemented by NSURL, Alamofire to perform the api calls.
///
/// The implementation is responsible to make the APi call and return Data.
protocol ApiExecuting: Hashable {
    
    init(request: ApiExecutingRequest)
    
    /// Executes the current request and returns Raw Data
    /// - Parameter callback:
    func execute(_ callback: @escaping (Result<Data, ApiError>) -> Void)
    
    /// Cancel request if in-flight
    /// A cancelled request never returns data
    func cancel()
    
}

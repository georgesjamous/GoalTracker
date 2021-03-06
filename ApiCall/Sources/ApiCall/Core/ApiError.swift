//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

public enum ApiError: Error {
    
    /// Request was cancelled by the device
    /// this happens mostly when there is no internet connection
    /// or when the session deallocates.
    /// for simplicity, we assume its network
    case timeout
    
    /// Expecting data but none was returned
    case noDataReturned
    
    /// Retruns an HTTP Error code with the Error
    case httpError(code: Int, error: Error?)
    
    /// the returned data does not match what we expected
    case notDecodable
    
}

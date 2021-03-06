//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

public typealias ApiRequestHeader = [String: String]

/// ApiRequestInterface represents the interface for an Api Request details
public protocol ApiRequestInterface {
    
    /// Request full URL or Path
    var url: URL { get }
    
    /// The HTTP Method to use for the request
    var method: ApiRequestMethod { get }
    
    /// Send custom headers with the request
    var headers: ApiRequestHeader? { get }
    
}

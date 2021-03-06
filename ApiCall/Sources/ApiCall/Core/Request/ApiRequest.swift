//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// ApiRequest is an implementation helper for __ApiRequestInterface__
/// that can be used when this library is imported.
public struct ApiRequest: ApiRequestInterface {
    public var url: URL
    public var method: ApiRequestMethod
    public var headers: ApiRequestHeader? = nil
    
    public init(url: URL, method: ApiRequestMethod) {
        self.url = url
        self.method = method
    }
}

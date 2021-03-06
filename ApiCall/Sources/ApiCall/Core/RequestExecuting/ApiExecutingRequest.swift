//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// A request to be executed by some executer.
/// We can have it as a protocol, but its not required since
/// this is the most vanilla type of executer request.
///
/// It only defines the minimum needed for an executed
/// to be able to execute a request.
struct ApiExecutingRequest {
    let url: URL
    let method: ApiRequestMethod
    let headers: ApiRequestHeader?
}

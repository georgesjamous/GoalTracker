//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// An NSURL implementation of an API Executer. 
///
/// Implemented quickly to showcase usecase
class NSURLApiExecuter: ApiExecuting {
    
    let id: UUID = UUID()
    let request: ApiExecutingRequest
    var urlSessionTask: URLSessionDataTask?
    
    required init(request: ApiExecutingRequest) {
        self.request = request
    }
    
    func execute(_ callback: @escaping (Result<Data, ApiError>) -> Void) {
        urlSessionTask = URLSession.shared.dataTask(with: request.url) { [weak self] (data, response, error) in
            guard
                let self = self,
                let httpResponse = response as? HTTPURLResponse
            else {
                callback(.failure(.timeout))
                return
            }
            let result = self.evaluateHttpResponse(httpResponse: httpResponse, error: error, data: data)
            callback(result)
        }
        urlSessionTask?.resume()
    }
    
    func cancel() {
        urlSessionTask?.cancel()
    }
    
    // a simple response evaluator
    private func evaluateHttpResponse(httpResponse: HTTPURLResponse, error: Error?, data: Data?) -> Result<Data, ApiError> {
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(ApiError.httpError(code: httpResponse.statusCode, error: error))
        }
        if let error = error {
            return .failure(.httpError(code: -1, error: error))
        }
        if let data = data {
            return .success(data)
        }
        // fallback to some generic error
        return .failure(.noDataReturned)
    }
    
    
    // MARK: Hashable
    
    static func == (lhs: NSURLApiExecuter, rhs: NSURLApiExecuter) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

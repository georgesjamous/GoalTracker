//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import ApiCall

/// An implementation of the service using remote
public class RemoteUserGoalService: UserGoalService {
    
    let apiService: ApiService
    
    required public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    // Mark: Path
    
    enum Paths {
        static var getGoals: URL { URL(string: "_ah/api/myApi/v1/goals")! }
    }
    
}

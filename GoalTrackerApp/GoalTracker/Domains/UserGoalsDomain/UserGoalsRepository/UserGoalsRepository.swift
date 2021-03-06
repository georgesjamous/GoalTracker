//
//  UserGoalsRepository.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine
import ApiCall
import UserGoalsService

/// UserGoalsRepository is responsible to interact with
/// the user goal service Api to fetch the remote goals.
///
/// Note:
/// there is no need to have this as a protocol since
/// abstractions are performed way down the stack.
class UserGoalsRepository {
  
    let apiService: RemoteUserGoalService
    
    init(apiService: RemoteUserGoalService) {
        self.apiService = apiService
    }
    
    /// fetches goals from api and returns them.
    func fetchGoals(callback: @escaping (Result<[Goal], UserGoalServiceError>) -> Void) {
        apiService.fetchUserGoals { (result) in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let goalObjectList):
                let goals = self.encode(goalObjects: goalObjectList)
                callback(.success(goals))
            }
        }
    }
    
    /// encodes a list of gol objects into a list of goals
    func encode(goalObjects: [GoalObject]) -> [Goal] {
        goalObjects.map { (element) -> Goal in
            goalFrom(goalObject: element)
        }
    }
    
    /// retun a goal from GoalObject
    func goalFrom(goalObject: GoalObject) -> Goal {
        // Note:
        // we could have created an __UserGoalObjectEncoder().encodeMany()__
        // to prevent creating multiple instances of __UserGoalObjectEncoder__.
        // however by having a single purpose we gain testability. Think JSONEncoder()
        UserGoalObjectEncoder().encode(goalObject: goalObject)
    }
    
}

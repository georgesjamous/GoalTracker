//
//  CoreDataStack.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine
import CoreData

/// UserGoalCoreDataPersistingStack interacts with the persistence layer
/// of the user goals to update and watch for changes
class UserGoalCoreDataPersisting {
    
    private var cancellableSet: Set<AnyCancellable> = Set()
    private let stack: UserGoalCoreDataPersistingStack

    init(stack: UserGoalCoreDataPersistingStack) {
        self.stack = stack
    }

}

extension UserGoalCoreDataPersisting: UserGoalPersisting {
    func saveGoals(_ goals: [Goal]) {
        _ = stack.saveGoals(goals: goals)
    }
    func fetchController(goalId: String?) -> GoalFetching {
        stack.goalsFetchController(goalId: goalId)
    }
}

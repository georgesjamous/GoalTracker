//
//  CoreDataGoalProgressPersisting.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import Combine
import CoreData

class CoreDataGoalProgressPersisting {
    
    private let stack: GoalProgressPersistingStack
    
    init(stack: GoalProgressPersistingStack) {
        self.stack = stack
    }
    
}

extension CoreDataGoalProgressPersisting: GoalProgressPersisting {
    func saveGoalProgress(_ records: [GoalProgress]) {
        _ = stack.saveProgressRecords(records)
    }
    func fetchController(date: Date, goalId: String?) -> GoalProgressFetching {
        stack.progressFetchController(date: date, goalId: goalId)
    }
}

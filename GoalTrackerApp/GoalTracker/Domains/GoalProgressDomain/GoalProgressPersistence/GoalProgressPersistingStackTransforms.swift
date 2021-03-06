//
//  GoalProgressPersistingStackTransforms.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import CoreData

class GoalProgressPersistingStackTransforms {
    @discardableResult
    func managedObjectFrom(_ record: GoalProgress, context: NSManagedObjectContext) -> NSManagedObject? {
        GoalProgressEntity(context: context, record: record)
    }
    func healthRecord(object: GoalProgressEntity) -> GoalProgress? {
        object.goalProgressModel
    }
}

// MARK: Internals

extension GoalProgressEntity {
    convenience init(context: NSManagedObjectContext, record: GoalProgress) {
        self.init(context: context)
        date = record.date.normalized
        goalId = record.goalId
        progress = record.percentageProgress
    }
    var goalProgressModel: GoalProgress? {
        guard
            let date = date,
            let goalId = goalId
        else { return nil }
        return GoalProgress(
            date: date,
            goalId: goalId,
            progressState: GoalProgressState(progress),
            // todo: remove
            reward: nil
        )
    }
}

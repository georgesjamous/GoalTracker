//
//  UserGoalCoreDataPersistingStackEncoder.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData

// Note:
// Usually we have Encoders and Decoders seperate
// but for speed i left them in the same file.

/// Responsible to Encode a __Goal__ to a persisted object
class UserGoalCoreDataPersistingStackTransforms {
    @discardableResult
    func managedObjectFromGoal(_ goal: Goal, context: NSManagedObjectContext) -> NSManagedObject? {
        if let goal = goal as? StepCountGoal {
            return StepsGoalEntity(context: context, goal: goal)
        } else if let goal = goal as? WalkingDistanceGoal {
            return WalkingDistanceGoalEntity(context: context, goal: goal)
        } else if let goal = goal as? RunningDistanceGoal {
            return RunningDistanceGoalEntity(context: context, goal: goal)
        }
        assertionFailure("Was not able to encode goal \(goal). Not supported.")
        return nil
    }
    func goal(object: NSManagedObject) -> Goal? {
        if let goal = object as? StepsGoalEntity {
            return goal.goalModel
        } else if let goal = object as? WalkingDistanceGoalEntity {
            return goal.goalModel
        } else if let goal = object as? RunningDistanceGoalEntity {
            return goal.goalModel
        }
        assertionFailure("Was not able to decode into Goal.")
        return nil
    }
}


// Note:
// we can split these to different files
// MARK: Internals

fileprivate extension RewardTrophy {
    init?(raw: String) {
        switch raw {
        case "bronze_medal":
            self = RewardTrophy.bronzeMedal
        case "zombie":
            self = RewardTrophy.zombie
        case "silver_medal":
            self = RewardTrophy.silverMedal
        case "gold_medal":
            self = RewardTrophy.goldMedal
        default:
            return nil
        }
    }
    var persistenceValue: String {
        switch self {
        case .bronzeMedal:
            return "bronze_medal"
        case .zombie:
            return "zombie"
        case .silverMedal:
            return "silver_medal"
        case .goldMedal:
            return "gold_medal"
        }
    }
}

extension RewardEntity {
    convenience init(context: NSManagedObjectContext, rewardable: GoalRewardable) {
        self.init(context: context)
        points = Int32(rewardable.points)
        trophy = rewardable.trophy.persistenceValue
    }
}


extension StepsGoalEntity {
    convenience init(context: NSManagedObjectContext, goal: StepCountGoal) {
        self.init(context: context)
        id = goal.id
        title = goal.title
        moreInfo = goal.description
        stepCount = Int32(goal.stepCount)
        rewardEntity = RewardEntity(context: context, rewardable: goal)
    }
    var goalModel: StepCountGoal? {
        guard
            let id = id,
            let title = title,
            let moreInfo = moreInfo,
            let rewardEntity = rewardEntity,
            let trophyValue = rewardEntity.trophy,
            let trophy = RewardTrophy(raw: trophyValue)
        else { return nil }
        return StepCountGoal(
            id: id,
            title: title,
            description: moreInfo,
            stepCount: Int(stepCount),
            trophy: trophy,
            points: Int(rewardEntity.points)
        )
    }
}

extension RunningDistanceGoalEntity {
    convenience init(context: NSManagedObjectContext, goal: RunningDistanceGoal) {
        self.init(context: context)
        id = goal.id
        title = goal.title
        moreInfo = goal.description
        distance = Int32(goal.distanceInMeters)
        rewardEntity = RewardEntity(context: context, rewardable: goal)
    }
    var goalModel: RunningDistanceGoal? {
        guard
            let id = id,
            let title = title,
            let moreInfo = moreInfo,
            let rewardEntity = rewardEntity,
            let trophyValue = rewardEntity.trophy,
            let trophy = RewardTrophy(raw: trophyValue)
        else { return nil }
        return RunningDistanceGoal(
            id: id,
            title: title,
            description: moreInfo,
            distanceInMeters: Double(distance),
            trophy: trophy,
            points: Int(rewardEntity.points)
        )
    }
}

extension WalkingDistanceGoalEntity {
    convenience init(context: NSManagedObjectContext, goal: WalkingDistanceGoal) {
        self.init(context: context)
        id = goal.id
        title = goal.title
        moreInfo = goal.description
        distance = Int32(goal.distanceInMeters)
        rewardEntity = RewardEntity(context: context, rewardable: goal)
    }
    var goalModel: WalkingDistanceGoal? {
        guard
            let id = id,
            let title = title,
            let moreInfo = moreInfo,
            let rewardEntity = rewardEntity,
            let trophyValue = rewardEntity.trophy,
            let trophy = RewardTrophy(raw: trophyValue)
        else { return nil }
        return WalkingDistanceGoal(
            id: id,
            title: title,
            description: moreInfo,
            distanceInMeters: Double(distance),
            trophy: trophy,
            points: Int(rewardEntity.points)
        )
    }
}

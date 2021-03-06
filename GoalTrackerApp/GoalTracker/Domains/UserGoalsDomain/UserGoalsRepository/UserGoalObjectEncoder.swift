//
//  UserGoalEncoder.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import UserGoalsService

// helper extension for conversion
fileprivate extension GoalTrophyType {
    var rewardTrophy: RewardTrophy {
        switch self {
        case .bronzeMedal:
            return .bronzeMedal
        case .goldMedal:
            return .goldMedal
        case .silverMedal:
            return .silverMedal
        case .zombieHand:
            return .zombie
        }
    }
}

/// Encodes a goal object to a usable Goal
class UserGoalObjectEncoder {
    func encode(goalObject: GoalObject) -> Goal {
        switch goalObject.type {
        case .runningDistance:
            return RunningDistanceGoal(
                id: goalObject.id,
                title: goalObject.title,
                description: goalObject.description,
                distanceInMeters: Double(goalObject.goal),
                trophy: goalObject.reward.trophy.rewardTrophy,
                points: goalObject.reward.points
            )
        case .step:
            return StepCountGoal(
                id: goalObject.id,
                title: goalObject.title,
                description: goalObject.description,
                stepCount: Int(goalObject.goal),
                trophy: goalObject.reward.trophy.rewardTrophy,
                points: goalObject.reward.points
            )
        case .walkingDistance:
            return WalkingDistanceGoal(
                id: goalObject.id,
                title: goalObject.title,
                description: goalObject.description,
                distanceInMeters: Double(goalObject.goal),
                trophy: goalObject.reward.trophy.rewardTrophy,
                points: goalObject.reward.points
            )
        }
    }
}

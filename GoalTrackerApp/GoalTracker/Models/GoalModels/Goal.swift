//
//  Goal.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

enum RewardTrophy {
    case zombie
    case silverMedal
    case bronzeMedal
    case goldMedal
}

protocol Goal: GoalRewardable {
    var id: String { get }
    var title: String { get }
    var description: String { get }
}

protocol GoalRewardable {
    var trophy: RewardTrophy { get }
    var points: Int { get }
}

protocol ChallengeDescribing {
    var challengeCriteriaDescription: String { get }
}

//
//  UserGoalsService+1.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

extension UserGoalsService: UserGoalsServiceDataControlling {
    @discardableResult
    func refreshGoals() -> Future<Void, DomainError> {
        Future { [weak self] response in
            guard let self = self else { return }
            self.userGoalsRepository.fetchGoals { (result) in
                switch result {
                case .failure(let error):
                    response(.failure(DomainError(error)))
                case .success(let goals):
                    self.userGoalsPersistence.saveGoals(goals)
                    response(.success(Void()))
                }
            }
        }
    }
}

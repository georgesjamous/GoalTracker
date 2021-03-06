//
//  UserGoalCoreDataPersistingStack.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData
import CoreDataStack
import Combine

/// UserGoalCoreDataPersistingStack is a lower level class
/// that interact directly with core datastack.
class UserGoalCoreDataPersistingStack {
    
    private let coreDataStack: MainCoreDataStack
    private var cancellableSet: Set<AnyCancellable> = Set()
    private let queue = DispatchQueue(label: "com.domain.UserGoalCoreDataPersistingStack", target: .persistence)

    init(coreDataStack: MainCoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    /// Returns a controller that can fetch all user goals
    func goalsFetchController(goalId: String? = nil) -> UserGoalCoreDataFetchController {
        UserGoalCoreDataFetchController(context: coreDataStack.backgroundContext, goalId: goalId)
    }
    
    /// Saves all goals to the db
    func saveGoals(goals: [Goal]) -> Future<Void, Error> {
        let context = coreDataStack.backgroundContext
        return Future { [weak self] result in
            guard let self = self else { return }
            self.queue.async {
                context.perform {
                    self._saveGoals(context: context, goals: goals, result: result)
                }
            }
        }
        
    }
    
    private func _saveGoals(
        context: NSManagedObjectContext,
        goals: [Goal],
        result: @escaping (Result<Void, Error>) -> Void
    ) {
        batchDelete(
            context: context,
            fetchRequests:
                StepsGoalEntity.fetchRequest(),
                RunningDistanceGoalEntity.fetchRequest(),
                WalkingDistanceGoalEntity.fetchRequest()
        )
        for goal in goals {
            UserGoalCoreDataPersistingStackTransforms()
                .managedObjectFromGoal(goal, context: context)
        }
        context.commitChanges { (commitResult) in
            switch commitResult {
            case .success:
                result(.success(Void()))
            case .failed(let error):
                result(.failure(error))
            }
        }
    }

    /// Deletes all objects of multiple fetch request
    ///
    /// Note:
    /// for now i am using context delete, but this could be imporved and be replaced by batch delete
    /// however i did not want to deal with the deletion of the relationships manually. So this is a quick one.
    private func batchDelete(
        context: NSManagedObjectContext,
        fetchRequests: NSFetchRequest<NSFetchRequestResult>...
    ) {
        for request in fetchRequests {
            if let objects: [Any] = try? context.fetch(request) {
                let managedObjects = objects.map({ $0 as? NSManagedObject }).compactMap({ $0 })
                managedObjects.forEach({ context.delete($0) })
            }
        }
    }
    
}

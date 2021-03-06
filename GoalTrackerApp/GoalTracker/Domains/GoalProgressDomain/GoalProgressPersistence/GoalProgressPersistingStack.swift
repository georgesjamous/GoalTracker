//
//  GoalProgressPersistingStack.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import CoreData
import CoreDataStack
import Combine

class GoalProgressPersistingStack {
    
    private let coreDataStack: MainCoreDataStack
    private var cancellableSet: Set<AnyCancellable> = Set()
    private let queue = DispatchQueue(label: "com.domain.GoalProgressPersistingStack", target: .persistence)

    init(coreDataStack: MainCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    /// Returns a controller that can fetch health record for a date
    func progressFetchController(date: Date, goalId: String?) -> GoalProgressFetching {
        GoalProgressFetchController(context: coreDataStack.backgroundContext, date: date, goalId: goalId)
    }
    
    /// update a record for health
    func saveProgressRecords(_ records: [GoalProgress]) -> AnyPublisher<Void, Error> {
        let context = coreDataStack.backgroundContext
        return Future<Void, Error> { [weak self] result in
            self?.queue.async {
                context.perform {
                    self?._saveProgressRecords(context: context, records: records, result: result)
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func _saveProgressRecords(
        context: NSManagedObjectContext,
        records: [GoalProgress],
        result: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            try self.removeExistingRecords(context: context, records: records)
            try self.saveRecords(context: context, records: records)
            context.commitChanges { (commitResult) in
                switch commitResult {
                case .success:
                    result(.success(Void()))
                case .failed(let error):
                    result(.failure(error))
                }
            }
        } catch {
            result(.failure(error))
        }
    }
    
    // Saves the new progress records
    // Note:
    // this should be moved to an external Operation class entity.
    private func saveRecords(context: NSManagedObjectContext, records: [GoalProgress]) throws {
        _ = records.map({
            GoalProgressPersistingStackTransforms()
                .managedObjectFrom($0, context: context)
        })
    }
    
    // one record per date-goalId, so we remove the old ones
    // we could have used batch delete, however i did not want to deal with relationship deletion
    // by it self for now.
    //
    // Note:
    // this should be moved to an external Operation class entity
    private func removeExistingRecords(context: NSManagedObjectContext, records: [GoalProgress]) throws {
        let fetchRequest = self.fetchRequestForRecordsDeletion(records: records)
        let results = try context.fetch(fetchRequest)
        results.forEach({ context.delete($0) })
    }
    
    private func fetchRequestForRecordsDeletion(records: [GoalProgress]) -> NSFetchRequest<GoalProgressEntity> {
        let goalIds = records.map{( $0.goalId )}
        let dates = records.map({ $0.date.normalized })
        let fetchRequest: NSFetchRequest<GoalProgressEntity> = GoalProgressEntity.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            // todo: key path
            NSPredicate(format: "date IN %@", dates as CVarArg),
            NSPredicate(format: "goalId IN %@", goalIds as CVarArg)
        ])
        return fetchRequest
    }
    
}

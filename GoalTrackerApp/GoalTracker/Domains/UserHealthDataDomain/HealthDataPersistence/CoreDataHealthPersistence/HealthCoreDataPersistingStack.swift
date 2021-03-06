//
//  HealthCoreDataPersistingStack.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData
import CoreDataStack
import Combine

/// The stack that interacts with core data
class HealthCoreDataPersistingStack {
    
    private let coreDataStack: MainCoreDataStack
    private var cancellableSet: Set<AnyCancellable> = Set()
    private let queue = DispatchQueue(label: "com.domain.HealthCoreDataPersistingStack", target: .persistence)

    init(coreDataStack: MainCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    /// Returns a controller that can fetch health record for a date
    func healthFetchController(date: Date) -> HealthCoreDataFetchController {
        HealthCoreDataFetchController(context: coreDataStack.backgroundContext, date: date)
    }
    
    /// update a record for health
    func updateHealthRecord(record: HealthRecord) -> Future<Void, Error> {
        let context = coreDataStack.backgroundContext
        return Future { [weak self] result in
            guard let self = self else { return }
            self.queue.async {
                context.perform {
                    self._updateHealthRecord(
                        context: context,
                        record: record,
                        result: result
                    )
                }
            }
        }
    }
    
    private func _updateHealthRecord(
        context: NSManagedObjectContext,
        record: HealthRecord,
        result: @escaping (Result<Void, Error>) -> Void
    ) {
        saveHealthRecord(context: context, record: record)
        context.commitChanges { (commitResult) in
            switch commitResult {
            case .success:
                result(.success(Void()))
            case .failed(let error):
                result(.failure(error))
            }
        }
    }
    
    // saves the new health record for the date
    private func saveHealthRecord(context: NSManagedObjectContext, record: HealthRecord) {
        let transforms = HealthCoreDataPersistingStackTransforms()
        let managedObject: HealthRecordElement = {
            if let existingRecord = try? self.recordForDate(context: context, date: record.date) {
                return existingRecord
            }
            return transforms.managedObjectFrom(record, context: context)
        }()
        transforms.updateRecord(object: managedObject, record: record)
    }

    
    // todo: split this
    private func recordForDate(context: NSManagedObjectContext, date: Date) throws -> HealthRecordElement? {
        let normalizedDate: Date = date.normalized
        let fetchRequest: NSFetchRequest<HealthRecordElement> = HealthRecordElement.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", normalizedDate as CVarArg)
        fetchRequest.fetchLimit = 1
        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
}

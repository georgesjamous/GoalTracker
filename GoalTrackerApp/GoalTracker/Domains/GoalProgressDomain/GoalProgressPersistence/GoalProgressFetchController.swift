//
//  GoalProgressFetchController2.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import CoreData
import Combine

/// A fetch controller that is responsible to watch for Goal updates.
/// Like _NSFetchedResultsController_
class GoalProgressFetchController: NSObject {
    
    let date: Date
    let goalId: String?
    
    private let context: NSManagedObjectContext
    private let subject = PassthroughSubject<[GoalProgress], Never>()
    
    init(context: NSManagedObjectContext, date: Date, goalId: String?) {
        self.context = context
        self.date = date
        self.goalId = goalId
    }
    
    // MARK: Fetch Controllers
    
    private var predicate: NSPredicate {
        var predicates = [NSPredicate(format: "date == %@", date.normalized as CVarArg)]
        if let goalId = goalId {
            predicates.append(NSPredicate(format: "goalId == %@", goalId as CVarArg))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private var fetchLimit: Int {
        goalId == nil ? 0 : 1
    }
    
    private lazy var fetchController: NSFetchedResultsController<GoalProgressEntity> = {
        let fetchRequest: NSFetchRequest<GoalProgressEntity> = GoalProgressEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ .init(key: (\HealthRecordElement.date).stringValue, ascending: true) ]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return resultController
    }()
    

    private func controllerDidChangeContent() {
        let transformer = GoalProgressPersistingStackTransforms()
        let objects = (fetchController.fetchedObjects ?? [])
        let transformedObjects = objects.map({ transformer.healthRecord(object: $0) }).compactMap({ $0 })
        subject.send(transformedObjects)
    }
    
}

extension GoalProgressFetchController: GoalProgressFetching {
    public var progressPublisher: AnyPublisher<[GoalProgress], Never> {
        subject.eraseToAnyPublisher()
    }
    public var changedProgressPublisher: AnyPublisher<[GoalProgress], Never> {
        // todo - implement this
        progressPublisher
    }
    /// Starts performing fetch.
    ///
    /// Safe to be called multiple times.
    public func startFetching() {
        fetchController.delegate = self
        try? fetchController.performFetch()
        
        // send one time event
        controllerDidChangeContent()
    }
    /// Stops performing fetches.
    /// Safe to be called multiple times.
    public func stopFetching() {
        fetchController.delegate = nil
    }
}

extension GoalProgressFetchController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        controllerDidChangeContent()
    }
}

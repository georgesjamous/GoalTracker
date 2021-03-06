//
//  HealthCoreDataFetchController.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData
import Combine

protocol HealthRecordFetching {
    var date: Date { get }
    var goalsPublisher: AnyPublisher<HealthRecord?, Never> { get }
    func startFetching()
    func stopFetching()
}

/// A fetch controller that is responsible to watch for Goal updates.
/// Like _NSFetchedResultsController_
class HealthCoreDataFetchController: NSObject, HealthRecordFetching {
    
    let date: Date
    private let context: NSManagedObjectContext
    private let subject = PassthroughSubject<HealthRecord?, Never>()
    
    public var goalsPublisher: AnyPublisher<HealthRecord?, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init(context: NSManagedObjectContext, date: Date) {
        self.context = context
        self.date = date
    }
    
    // MARK: Fetch Controllers
    
    private lazy var fetchController: NSFetchedResultsController<HealthRecordElement> = {
        let fetchRequest: NSFetchRequest<HealthRecordElement> = HealthRecordElement.fetchRequest()
        fetchRequest.sortDescriptors = [ .init(key: (\HealthRecordElement.date).stringValue, ascending: true) ]
        fetchRequest.predicate = NSPredicate(format: "date == %@", date.normalized as CVarArg)
        fetchRequest.fetchLimit = 1
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultController.delegate = self
        return resultController
    }()
    
    /// Starts performing fetch.
    ///
    /// Safe to be called multiple times.
    public func startFetching() {
        try? fetchController.performFetch()
        
        // send one time event
        self.valueChanged()
    }
    
    /// Stops performing fetches.
    /// Safe to be called multiple times.
    public func stopFetching() {
        fetchController.delegate = nil
    }
    
    public func valueChanged() {
        let transformer = HealthCoreDataPersistingStackTransforms()
        if let objects1: HealthRecordElement = (fetchController.fetchedObjects ?? []).first {
            subject.send(transformer.healthRecord(object: objects1))
        } else {
            subject.send(nil)
        }
    }

}

extension HealthCoreDataFetchController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        valueChanged()
    }
}

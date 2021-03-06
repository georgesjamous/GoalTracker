//
//  UserGoalCoreDataFetchController.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData
import Combine

/// A fetch controller that is responsible to watch for Goal updates.
///
/// todo:
/// Optimize this by turning off unneded fech controller when fetching a single goal
class UserGoalCoreDataFetchController: NSObject {
    
    deinit {
        precondition(!isFetching, "Stop fetch first")
    }
    
    // todo: lock this
    private(set) var isFetching: Bool = false
    private let context: NSManagedObjectContext
    private let subject = PassthroughSubject<[Goal], Never>()
    private var goalId: String?

    init(context: NSManagedObjectContext, goalId: String? = nil) {
        self.context = context
        self.goalId = goalId
    }
    
    // MARK: Fetch Controller
        
    var predicate: NSPredicate? {
        if let goalId = goalId {
            return .init(format: "id == %@", goalId)
        } else {
            return nil
        }
    }
    
    var fetchLimit: Int {
        goalId == nil ? 0 : 1
    }
    
    private lazy var stepGoalFetchController: NSFetchedResultsController<StepsGoalEntity> = {
        let fetchRequest: NSFetchRequest<StepsGoalEntity> = StepsGoalEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ .init(key: (\StepsGoalEntity.title).stringValue, ascending: true) ]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultController.delegate = self
        return resultController
    }()
    
    private lazy var walkingGoalFetchController: NSFetchedResultsController<WalkingDistanceGoalEntity> = {
        let fetchRequest: NSFetchRequest<WalkingDistanceGoalEntity> = WalkingDistanceGoalEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ .init(key: (\WalkingDistanceGoalEntity.title).stringValue, ascending: true) ]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultController.delegate = self
        return resultController
    }()
    
    private lazy var runningGoalFetchController: NSFetchedResultsController<RunningDistanceGoalEntity> = {
        let fetchRequest: NSFetchRequest<RunningDistanceGoalEntity> = RunningDistanceGoalEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ .init(key: (\RunningDistanceGoalEntity.title).stringValue, ascending: true) ]
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultController.delegate = self
        return resultController
    }()
    

    /// Note:
    /// we could add a __throttle__ here to prevent multiple consecurive updates
    public func goalsValueChanged() {
        let transformer = UserGoalCoreDataPersistingStackTransforms()
        
        let objects1 = stepGoalFetchController.fetchedObjects ?? []
        let objects2 = walkingGoalFetchController.fetchedObjects ?? []
        let objects3 = runningGoalFetchController.fetchedObjects ?? []
        
        let final: [Goal] = (objects1.map({ transformer.goal(object: $0) }) +
            objects2.map({ transformer.goal(object: $0) }) +
            objects3.map({ transformer.goal(object: $0) }))
            .compactMap({ $0 })
        
        subject.send(final)
    }
}

extension UserGoalCoreDataFetchController: GoalFetching {
    public var goalsPublisher: AnyPublisher<[Goal], Never> {
        subject.eraseToAnyPublisher()
    }
    var removedGoalsPublisher: AnyPublisher<[Goal], Never> {
        Just([]).eraseToAnyPublisher()
    }
    var addedGoalsPublisher: AnyPublisher<[Goal], Never> {
        Just([]).eraseToAnyPublisher()
    }
    public var changedGoalsPublisher: AnyPublisher<[Goal], Never> {
        // todo:
        goalsPublisher
    }
    /// Starts performing fetch.
    ///
    /// Safe to be called multiple times.
    public func startFetching() {
        guard !isFetching else { return }
        isFetching = true
        
        try? stepGoalFetchController.performFetch()
        try? walkingGoalFetchController.performFetch()
        try? runningGoalFetchController.performFetch()
        
        // send one time event
        self.goalsValueChanged()
    }
    /// Stops performing fetches.
    /// Safe to be called multiple times.
    ///
    /// Note:
    /// we could also delete and recreate the fetch controllers.
    /// but setting delegate to nil does stop fetching per apple docs.
    public func stopFetching() {
        guard isFetching else { return }
        stepGoalFetchController.delegate = nil
        walkingGoalFetchController.delegate = nil
        runningGoalFetchController.delegate = nil
        isFetching = false
    }
}

extension UserGoalCoreDataFetchController: NSFetchedResultsControllerDelegate {
//    func controller(
//        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
//        didChangeContentWith diff: CollectionDifference<NSManagedObjectID>
//    ) {}
//    func controller(
//        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
//        didChange anObject: Any,
//        at indexPath: IndexPath?,
//        for type: NSFetchedResultsChangeType,
//        newIndexPath: IndexPath?
//    ) {}
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        goalsValueChanged()
    }
}

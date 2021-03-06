//
//  MainCoreDataStack.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import CoreDataStack
import CoreData
import Combine

/// Note:
/// MainCoreDataStack is a wrapper around the _CoreDataStack_ Library.
/// It is emtpy for now, we might use this to add extra stuff
class MainCoreDataStack {
    
    private let coreDataStack: CoreDataStack
    private var cancellableSet: Set<AnyCancellable> = Set()
    
    // this shoud be injected for testability
    init() {
        let url = Bundle.main.url(forResource: "MainModel", withExtension: "momd")!
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Model not dound")
        }
        coreDataStack = CoreDataStack(mode: .onDisk(identifier: "com.MainModel"), model: model)
    }
    

    var backgroundContext: NSManagedObjectContext { coreDataStack.backgroundContext }
    
    var readerContext: NSManagedObjectContext { coreDataStack.readerContext }
    
}

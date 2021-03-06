import CoreData

/// CoreDataStack is a helper stack reusable to get us started quickly
public final class CoreDataStack {
    
    public enum Mode {
        case inMemory
        case onDisk(identifier: String)
    }
    
    let mode: Mode
    let model: NSManagedObjectModel

    /// Initialize the stack with a usage mode
    /// - Parameters:
    ///   - mode: the mode to use for the stack the backed storeage
    ///   - model: the model to use
    public init(
        mode: Mode,
        model: NSManagedObjectModel
    ) {
        self.model = model
        self.mode = mode
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        switch mode {
        case .inMemory:
            return PersistentStoreCoordinator.inMemory(model: model)
        case .onDisk(identifier: let identifier):
            return PersistentStoreCoordinator.onDisk(model: model, identifier: identifier)
        }
    }()
    
    /// This context will operate on a private queue (Background)
    /// Use this for Read and Writes
    public lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
    /// This context will operate on the main thread
    /// Use this only for reads
    public lazy var readerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = backgroundContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
}

import XCTest
@testable import CoreDataStack
import CoreData

final class CoreDataStackTests: XCTestCase {
    
    func testObjectsAreSavedAndRetreived() {
        let stack = CoreDataStack(mode: .inMemory, model: NSManagedObjectModel.testModel)
        
        let testEntity = stack.backgroundContext.testModel
        XCTAssertNoThrow(try stack.backgroundContext.save())
        
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        let result = try! stack.backgroundContext.fetch(fetchRequest)
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.first?.name == testEntity.name)
    }
    
    func testObjectsFromMultipleStacksDoesNotCollide() {
        let stack1 = CoreDataStack(mode: .inMemory, model: NSManagedObjectModel.testModel)
        let stack2 = CoreDataStack(mode: .inMemory, model: NSManagedObjectModel.testModel)

        let testEntity1 = stack1.backgroundContext.testModel
        let testEntity2 = stack2.backgroundContext.testModel
        XCTAssertNotEqual(testEntity1.name, testEntity2.name)

        XCTAssertFalse(stack1.backgroundContext.fetchAllModels.isEmpty)
        XCTAssertFalse(stack2.backgroundContext.fetchAllModels.isEmpty)

        XCTAssertEqual(stack1.backgroundContext.fetchAllModels.first?.name, testEntity1.name)
        XCTAssertEqual(stack2.backgroundContext.fetchAllModels.first?.name, testEntity2.name)
    }

    func testThatbackgroundContextInOnMainQueue() {
        let stack = CoreDataStack(mode: .inMemory, model: NSManagedObjectModel.testModel)
        XCTAssertTrue(stack.readerContext.concurrencyType == .mainQueueConcurrencyType, "Expected reader context to work on main queue")
    }

    func testThatWriterContextInOnPrivateQueue() {
        let stack = CoreDataStack(mode: .inMemory, model: NSManagedObjectModel.testModel)
        XCTAssertTrue(stack.backgroundContext.concurrencyType == .privateQueueConcurrencyType, "Expected writer context to work on private queue")
    }
}

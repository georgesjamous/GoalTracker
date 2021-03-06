//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData

public enum SaveContextResult {
    case success
    case failed(Error)
}

public extension NSManagedObjectContext {
    func commitChanges(completion: @escaping (SaveContextResult) -> Void) {
        guard hasChanges else {
            completion(.success)
            return
        }
        perform {
            do {
                try self.save()
            } catch {
                completion(.failed(error))
                return
            }
            if let parentContext = self.parent {
                parentContext.commitChanges(completion: completion)
            } else {
                completion(.success)
            }
        }
    }
}

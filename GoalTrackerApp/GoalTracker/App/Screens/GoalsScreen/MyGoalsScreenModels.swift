//
//  MyGoalsScreenModels.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// Note:
/// This holds the data that is shared between the module.
/// This is use along side the Contact __MyGoalsScreenInterfaces__.
/// It acts like a usecase
enum MyGoalsScreenModels {
    
    // Note:
    // We could also define the errors that we handle for business cases in this module.
    // But i am using DomainError (which is on a higher level) to speed things up.
    // If we want to show errors in alerts we could user __LocalizedError__.
    // Or if we have some other mechanism we will localize it in UIView/Presenter.
    // enum Errors: LocalizedError {
    //     case someBusinessError
    //     case other(DomainError)
    // }
    
    enum RefreshState {
        case refreshing
        case failed(DomainError)
        case succeeded
    }
}

//
//  Application+DI.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import UserGoalsService
import HealthDataProvider

// Note:
// [a]
// In practice, we could move DI registration to the domain
// and have the domain register it-self with a container
// for now this is okay since we have few domains.
//
// [b]
// Core data stack is a (Weak) singleton for all domains.
// All domains interact with a single DataStack. And when
// no references exists, it gets dealocated.
//
// [C]
// Services are stateless and thus are not required to be singleton.
// Hoever since services also act like factories its okay to have them
// be shared within a graph (Container). Up until no one is using them,
// then they get dealocated. That way we dont overcrowd the memory with needless services.

extension Application {
    
    func setupDI() {
        setupMainCoreDataStack()
        setupGoalDomain()
        setupHealthDataDomain()
        setupGoalTracking()
        
        #if DEBUG
        overrideDI()
        #endif
    }
    
    private func setupMainCoreDataStack() {
        container
            .register(MainCoreDataStack.self) { _ in MainCoreDataStack() }
            .inObjectScope(.weak)
    }
    
    private func setupGoalDomain() {
        //
        //
        // Peristence
        container.register(UserGoalCoreDataPersistingStack.self) { r in
            let coreDataStack = r.resolve(MainCoreDataStack.self)!
            return UserGoalCoreDataPersistingStack(coreDataStack: coreDataStack)
        }.inObjectScope(.weak) // Must be a singleton
        container.register(UserGoalPersisting.self) { r in
            let stack = r.resolve(UserGoalCoreDataPersistingStack.self)!
            return UserGoalCoreDataPersisting(stack: stack)
        }
        //
        //
        // Repository
        container.register(UserGoalsRepository.self) { r in
            let apiService = r.resolve(RemoteUserGoalService.self)!
            return UserGoalsRepository(apiService: apiService)
        }
        //
        //
        // Service
        container.register(UserGoalsService.self) { r in
            UserGoalsService(
                repository: r.resolve(UserGoalsRepository.self)!,
                persistence: r.resolve(UserGoalPersisting.self)!
            )
        }
        .inObjectScope(.weak)
        container.register(UserGoalsServiceDataProviding.self) { r in
            r.resolve(UserGoalsService.self)!
        }
        container.register(UserGoalsServiceDataControlling.self) { r in
            r.resolve(UserGoalsService.self)!
        }
        //
        //
        // Api
        container.register(UserGoalsApiService.self) { _ in
            UserGoalsApiService(url: AppConstants.goalsServiceBaseUrl)
        }
        container.register(RemoteUserGoalService.self) { r in
            let apiService = r.resolve(UserGoalsApiService.self)!
            return RemoteUserGoalService(apiService: apiService)
        }
    }
    
    private func setupHealthDataDomain() {
        //
        //
        // Peristence
        container.register(HealthCoreDataPersistingStack.self) { r in
            return HealthCoreDataPersistingStack(coreDataStack: r.resolve(MainCoreDataStack.self)!)
        }.inObjectScope(.weak) // Must be a singleton
        container.register(HealthDataPersisting.self) { r in
            let stack = r.resolve(HealthCoreDataPersistingStack.self)!
            return CoreDataHealthPersisting(stack: stack)
        }
        //
        //
        // Repository
        container.register(WalkingDistanceHealthDataProviding.self) { (_, start, end) -> WalkingDistanceHealthDataProviding in
            AppleDistanceWalkingHealthProvider(startDate: start, endDate: end)
        }
        container.register(RunningDistanceHealthDataProviding.self) { (_, start, end) -> RunningDistanceHealthDataProviding in
            AppleDistanceRunningHealthProvider(startDate: start, endDate: end)
        }
        container.register(StepHealthDataProviding.self) { (_, start, end) -> StepHealthDataProviding in
            AppleStepHealthProvider(startDate: start, endDate: end)
        }
        container.register(HealthDataRepository.self) { (_, date) -> HealthDataRepository in
            HealthDataRepository(date: date)
        }
        //
        //
        // Service
        container.register(HealthDataService.self) { (r) -> HealthDataService in
            HealthDataService(persistence: r.resolve(HealthDataPersisting.self)!)
        }.inObjectScope(.weak)
        container.register(HealthDataServiceDataProviding.self) { (r) -> HealthDataServiceDataProviding in
            r.resolve(HealthDataService.self)!
        }
        container.register(HealthDataServiceDataControlling.self) { (r) -> HealthDataServiceDataControlling in
            r.resolve(HealthDataService.self)!
        }
    }
    
    private func setupGoalTracking() {
        //
        //
        // Peristence
        container.register(GoalProgressPersistingStack.self) { r in
            let mainStack = r.resolve(MainCoreDataStack.self)!
            return GoalProgressPersistingStack(coreDataStack: mainStack)
        }.inObjectScope(.weak)
        container.register(GoalProgressPersisting.self) { r in
            return CoreDataGoalProgressPersisting(stack: r.resolve(GoalProgressPersistingStack.self)!)
        }
        //
        //
        // Repository
        // [NONE]
        //
        //
        // Service
        container.register(GoalProgressService.self) { (r) -> GoalProgressService in
            GoalProgressService(
                persistence: r.resolve(GoalProgressPersisting.self)!,
                goalDataProvider: r.resolve(UserGoalsServiceDataProviding.self)!,
                healthDataProvider: r.resolve(HealthDataServiceDataProviding.self)!
            )
        }.inObjectScope(.weak)
        container.register(GoalProgressServiceControlling.self) { (r) -> GoalProgressServiceControlling in
            r.resolve(GoalProgressService.self)!
        }
        container.register(GoalProgressServiceDataProviding.self) { (r) -> GoalProgressServiceDataProviding in
            r.resolve(GoalProgressService.self)!
        }
    }

}

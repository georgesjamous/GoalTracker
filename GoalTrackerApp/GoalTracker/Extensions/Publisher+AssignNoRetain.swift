//
//  Publisher+AssignNoRetain.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Combine

/// the default .assign in combine retains.
extension Publisher where Self.Failure == Never {
    public func assignNoRetain<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}

# Goal Tracker
### Data Models

Although in this project i am Encoding and Decoding models from NSManagedObjects to Structs. 
Its not the way to go, and I did not have time to correct this. As i started working quickly.

A far better way would be to create a `Protocol` and have the `NSManagedObject` adhere to it. 

That way, decoding and encoding is reduced and we will be interacting with the `NSManagedObject's` internal store and we get the benefit of memory optimizations.

A quick example of what i wanted to fix.

```swift
protocol Goal {
  let name: String { get }
}

// somewhere else
extension GoalEntityManagedObject: Goal {
   var name: String { goalName }
}
```

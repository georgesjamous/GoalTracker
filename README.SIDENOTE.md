# Goal Tracker
### Side Note

This is some personal notes on the project.

<br>
    
Things I wanted to do but did not have time for:

    1- Logging service
    2- I wanted to implement Goal Pagination and Batching
    3- I wanted to implement Proper HealthKit Authorization Check and UI
    4- I wanted to implement Trophy Gain Alert when someone gains trophies
    5- More testing
    6- Implement protocols on models instead of structs (this is referred to in Discussion Section)
    7- Clean the code a bit
    8- Use SwiftGen for Localization
    9- Use SwiftLint for linting and sanitization
    10- Moving all logic, each to its own Operation-(NSOperation) instead of inside functions
    11- UITableViewCell with SwiftUI view optimization by updating the model rather than recreating the view on reuse.

---

What i spent most of my time on

- Apple HealthKit:
  It has been a while since i worked with heakth kit, it took me some time to go through the docs and implement the ProviderLibrary.
  But i started with an abstraction, then the Mock. 
  That helped me get started before i finished implementing the HealthKit intergration.
 
---

Opinion on code challenge:

    Challenge is interesting although requires more time than a Weekend (2 Days).

    Since its basically a functional Application with a purpose, i often found my 
    self in the MVP dilema where on one side, i wanted to finish the user journey, 
    and on the other i wanted to write clean and separated code for the _reader_ to understand.

    So it took some time to balance the two.
    I also think a small design/layout suggestion would have been helpfull
    to remove any doubts of what is expected to show

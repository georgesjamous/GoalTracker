# HealthDataProvider

This library is responsible to communicate with the health data providers, transform the data then return it to us.

For now this is __quickly implemented__ with a Mock that emitts data every 1 second, and a AppleHealth intergration that received update from the HealthKit Api.

Walking, Running and Step records are devided into different providers. This will allow us to interact with multiple data providers for different categories.



# Goal Tracker
### Schemes

I wanted a way to switch schemes and build the app in mock mode. Mock mode uses a mock health data provider that emits new data every one second.

I went with the quicker aproach of creating a new Scheme with a Launch config, to override class creation using DI Container.

A better but more time consuming aprocach is to use a completely new Target. That way we dont risk the Mock data files compiling with our code that is shipped.

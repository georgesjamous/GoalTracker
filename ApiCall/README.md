# ApiLibrary

This is a Simple (Network) Api Library that is implemented in URLSession.

It can be extended to implement the famous Alamofire for example.

It is Simple to use for our usecase and can be expanded for additinal HTTP Methods, Upload, Download, Token...

Please check the comments for additional explanation.

This `ApiService` service can be passed around to other libraries to make network calls.


# Example
```swift
let service1 = ApiService(url: "https://service1.website.com")
let service2 = ApiService(url: "https://files.website.com")
let service3 = ApiService() // without a base URL

// Get Request Sample
let request = ApiRequest(url: URL(string: "people/id/123"), method: .get)
service1.performRequest(request) { [weak self] (result) in
    guard let self = self else { return }
    switch result {
    case .failure(let error):
    case .success(let data):
    }
}
```

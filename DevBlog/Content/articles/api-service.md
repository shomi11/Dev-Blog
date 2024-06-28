---
tags: Swift, Api, URLSession, Request
lastModified: 2024-05-19
---

## Swift API Service Creation

This guide demonstrates how to create an API service in Swift using URLSession for handling network requests. We'll walk through the implementation of an APIService class and provide an example of its usage in fetching data asynchronously.

#### APIService Class

The APIService class is designed to manage API requests and handle responses. It includes error handling and decoding of JSON responses into Swift's Decodable types.

```swift 
// APIService class to handle API requests
class APIService {
    
    // Singleton instance
    static let shared = APIService()
    
    // Error handling properties
    var errorMessage = String()
    var errCode = Int()
    
    // URLSession configuration and session
    var config: URLSessionConfiguration
    var session: URLSession
    
    // Initializer
    init() {
        config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 240
        config.timeoutIntervalForResource = 240
        session = URLSession(configuration: config)
    }
    
    // Fetch function to make API requests and decode the response
    func fetch<T: Decodable>(type: T.Type, router: Router) async throws -> T? {
        let (data, response) = try await session.data(for: router.request())
        switch response.getStatusCode()! {
        case 200...300:
            return data as? T 
        case 652:
            let handler = try? JSONDecoder().decode(ApiErrorHandling.self, from: data)
            self.errorMessage = handler?.message ?? "An error has occurred."
            throw ApiError.mergeGoogle
        }
        ...
    }
    
}
```

<br>

##### Explanation
    - Singleton Pattern: The APIService uses a singleton pattern to ensure a single instance throughout the app.
    - Configuration: The URLSessionConfiguration is set with custom timeout intervals.
    - Fetch Function: The fetch function performs an API request, decodes the JSON response, and handles different HTTP status codes.
    
<br>

#### Example Usage

Below is an example of how to use the APIService to fetch data asynchronously.

```swift
private func getDefaultMenu(storeID: Int) async -> MenuMaster? {
    withAnimation {
        menuState.isLoadingMenu = true
    }
    do {
        if let storeMenu = try await APIService.shared.fetch(type: MenuMaster.self, router: .getMenu(siteID: storeID)) {
            await CttService.shared.resetOrderIn()
            withAnimation {
                menuState.isLoadingMenu = false
            }
            return storeMenu
        } else {
            menuState.isLoadingMenu = false
            error = .someDefault(message: "Sorry, something went wrong, please try again.")
        }
    } catch {
        menuState.isLoadingMenu = false
        self.error = .api(message: APIService.shared.errorMessage)
    }
    return nil
}
```

<br>

#### Conclusion

This guide provides a basic structure for creating and using an API service in Swift. The APIService class can be extended with more functionality and customized error handling as needed. The example demonstrates how to call the service and handle the results effectively within a SwiftUI view.

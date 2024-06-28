---
tags: Swift, URLSession, Router
lastModified: 2024-05-19
---

## URLSession router in Swift

This guide demonstrates how to create a router for managing network requests using URLSession in Swift. We'll define a base URL, create an enum for routing different API endpoints, and provide a detailed example of how to configure and make requests.

#### Defining Base URL and Properties

First, we define the base URL and other necessary properties for our network requests.

##### Implementation
```swift
static var URL_P_NAME_WEB_BASE = "https://{yours}.azurewebsites.net"
static var AES_key256 = "{key}"
static var AES_iv = "{iv}"
static var AES_TOKEN_REQUEST = "{token}"
static let platformType: PlatformType = .iOS
```
#### Explanation
    - Base URL: The URL_P_NAME_WEB_BASE is the base URL for the API.
    - AES Key and IV: These properties are used for encryption (if applicable).
    - Token: The AES_TOKEN_REQUEST is used for token-based authentication(if applicable).
    - Platform Type: Specifies the platform type (e.g., iOS).(if applicable)

#### Creating the Router

We define an enum Router to manage different API endpoints and their configurations.

##### Implementation
```swift
enum Router {    
    
    static let baseUrl = URL_HS_WEB_BASE + "/api/"
    
    case refreshToken
    case forgotPassword(forgotPassObj: CustomerForgotPassword)
    // Add more cases as needed
    
    enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            }
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refreshToken, .forgotPassword:
            return .post
        case .getCustomer:
            return .get
        case .updateCustomer:
            return .put
        case .deleteSavedCreditCard, .deleteReloadConfig:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "v2/RefreshToken"
        case .forgotPassword:
            return "v3/Customer/Password/Forgot"
        // Add more cases with their respective paths
    }
    
    func request() throws -> URLRequest {
        
        let urlString = "\(Router.baseUrl)\(path)"
        
        guard let url = URL(string: urlString) else {
            throw Errors.parseUrlFail
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        request.httpMethod = method.value
        request.addValue(.COMPANY_CODE, forHTTPHeaderField: "CompanyCode")
        request.addValue(.platformType, forHTTPHeaderField: "PlatformType")

        switch self {
        case .refreshToken:
            let refreshToken: String? = .refreshTokenValue
            let paramsString = "refresh_token=\(refreshToken ?? "")&grant_type=\("refresh_token")"
            let body = paramsString.data(using: String.Encoding.utf8)
            request.httpBody = body
            return request
        }
        // Add more cases with their respective configurations
    }
}
```

#### Explanation
    - Router Enum: The Router enum defines different cases for each API endpoint.
    - HTTPMethod Enum: Defines the HTTP methods (GET, POST, PUT, DELETE) and their string values.
    - Method Property: Returns the HTTP method for each case.
    - Path Property: Returns the endpoint path for each case.
    - Request Function: Configures the URLRequest for each API endpoint, including setting the URL, HTTP method, headers, and body (if needed).
    
#### Example Usage

Below is an example of how to use the Router to create and send a request.

```swift
func performRequest() async {
    do {
        let request = try Router.refreshToken.request()
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Handle response and data
    } catch {
        print("Request error: \(error)")
    }
}
```
<br>

#### Explanation
    - Creating Request: The request() function of Router is called with the appropriate case (e.g., refreshToken).
    - Sending Request: The URLSession.shared.data(for:) method sends the request and retrieves the response.

<br>


##### Conclusion

This guide provides a structured approach to creating and managing network requests using a router pattern in Swift. The Router enum helps organize different API endpoints, making the code more maintainable and scalable. You can extend the Router with additional endpoints and customize the request configurations as needed.

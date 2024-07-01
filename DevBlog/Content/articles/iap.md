---
tags: Swift, iOS
lastModified: 2024-03-23
---

# In-App Purchases

Adding In-App Purchases (IAP) to your app can enhance user experience and generate revenue. Here’s a step-by-step guide to setting up IAP in App Store Connect.

### Adding a New Product (IAP)


<img src="/images/iap-article/main_iap.png" alt="Distribution Page" style="width: 100%; max-width: 600px;">

    <br>

1. **Navigate to the Distribution Page:**
   - Find the bottom left corner of your app’s Distribution page in App Store Connect.

    <img src="/images/iap-article/add_iap_plus.png" alt="" style="width: 100%; max-width: 600px;">

2. **Add a New Product:**
   - Click the plus sign to add a new product (IAP).
    
    <br>
    
    <img src="/images/iap-article/type_iap.png" alt="" style="width: 100%; max-width: 600px;">

### Choose the Type of IAP

There are two types of In-App Purchases:

- **Consumable:** These can be purchased, used, and bought again. For example, health points in a game.
- **Non-consumable:** These are purchased once and owned forever. This could be a one-time purchase for a feature or all features in the app.

### Setting Up Your IAP

- **Reference Name:** This is an internal name for App Store Connect to use in reports. It won't be shown to users.
- **Product ID:** This is a unique alphanumeric ID that must be unique across all your IAPs in all apps. This is the ID you will call in your code to request details and initiate purchases.

Once you've filled in the necessary details, save your product. If the system doesn't automatically take you to the next page, click on your newly saved IAP.
    
    <img src="/images/iap-article/details_iap.png" alt="" style="width: 100%; max-width: 600px;">

### Configure IAP Details

Here, you need to set various options:

- **Price:** Set the price of your IAP.
- **Availability:** Choose the countries where your IAP will be available.
- **Localization:** Provide translations for different languages if necessary.

**Review Information:**
It’s crucial to fill this section extensively. Detailed information here will help ensure that your review passes the check immediately.

### Implementing IAP in Your App

Now let’s move on to the code side of things. 

**1. Track User Purchases:**

Create an observable object to track important behaviors in the app, such as the type of user (free or premium).

```swift
class ApplicationState: ObservableObject {
    @Published var route: AppRouter = .splash
    @Published var isPremiumUser: Bool = false
}
```

And here is IAP manager that can help anyone as a starting point.


```swift
import Foundation
import StoreKit

class IAStoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @Published var products: [SKProduct] = []
    @Published var purchasedProductIdentifiers: Set<String> = []

    override init() {
        super.init()
        loadPurchasedProducts()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func fetchProducts() {
        let productIdentifiers = Set(["your_product_id"])
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: any Error) {
        print(error)
    }
    
    func requestDidFinish(_ request: SKRequest) { }

    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                savePurchasedProduct(identifier: transaction.payment.productIdentifier)
                loadPurchasedProducts()
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                savePurchasedProduct(identifier: transaction.payment.productIdentifier)
                loadPurchasedProducts()
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: any Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .restoreFailed, object: error.localizedDescription)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func savePurchasedProduct(identifier: String) {
        var purchasedProducts = UserDefaults.standard.array(forKey: "purchasedProducts") as? [String] ?? []
        purchasedProducts.append(identifier)
        UserDefaults.standard.set(purchasedProducts, forKey: "purchasedProducts")
    }

    private func loadPurchasedProducts() {
        let purchasedProducts = UserDefaults.standard.array(forKey: "purchasedProducts") as? [String] ?? []
        purchasedProductIdentifiers = Set(purchasedProducts)
    }
}
```

import UIKit
import StoreKit
import SwiftyJSON

@objc class SubscriptionManager: NSObject {
    
    static let shared = SubscriptionManager()
    
    static let weekProductID = "org.LifeHacks.week"
    
    var productsRequest: SKProductsRequest?
    var refreshReceiptRequest: SKReceiptRefreshRequest?
    var productsCallback: (([SKProduct]) -> Void)?
    
    var products = [String: SKProduct]()
    
    var subscriptionOfferIsShowing = false
    
    var isSubscriptionActive: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isSubscriptionActive")
            NotificationCenter.default.post(name: .SubscriptionStatusNotification,
                                            object: newValue)
        }
        get {
            let value = UserDefaults.standard.value(forKey: "isSubscriptionActive") as? Bool ?? false
            return value
        }
    }
    
    var isTrialUsed: Bool {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return FileManager.default.fileExists(atPath: receiptUrl.path)
    }
    
    class func sharedInstance() -> SubscriptionManager {
        return shared
    }
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        checkSubscriptionStatus()
        requestProducts()
    }
    
    public func requestProducts(_ ids: [String]? = nil, completion: (([SKProduct]) -> Void)? = nil) {
        let productIds = ids ?? [SubscriptionManager.weekProductID]
        
        guard products.isEmpty else {
            var products = [SKProduct]()
            for id in productIds {
                if let product = self.products[id] {
                    products.append(product)
                }
            }
            completion?(products.sorted(by: { (pr1, pr2) -> Bool in
                return pr1.price.intValue < pr2.price.intValue
            }))
            return
        }
        
        productsRequest?.cancel()
        productsCallback = completion
        productsRequest = SKProductsRequest(productIdentifiers: Set(productIds))
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    static func localizedPrice(productId: String) -> String {
        guard let product = shared.products[productId] else {
            return ""
        }
        let price = product.price
        let priceLocale = product.priceLocale
        print(priceLocale.currencySymbol)
        if priceLocale.currencyCode == "RUB" {
            return "\(price) ₽"
        } else {
            return "\(priceLocale.currencySymbol ?? "")\(price)"
        }
    }
    
    public func buyProduct(id: String)  {
        SKPaymentQueue.default().add(self)
        guard SubscriptionManager.canMakePayments() else {
            UIAlertController.show(message: "Purchases are turned off".localized())
            return
        }
        guard let product = products[id] else {
            UIAlertController.show(message: "Product not found.")
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func checkSubscriptionStatus() {
        guard let receiptData = loadReceipt() else {
            if refreshReceiptRequest != nil {
                refreshReceiptRequest = nil
                isSubscriptionActive = false
                return
            }
            resfreshReceipt()
            return
        }
        
        validateReceipt(data: receiptData) { (expireDate, isTrial) in
            guard let expireDate = expireDate, let _ = isTrial else { return }
            let isActive = expireDate > Date()
            self.isSubscriptionActive = isActive
        }
    }
    
    func resfreshReceipt() {
        refreshReceiptRequest = SKReceiptRefreshRequest()
        refreshReceiptRequest?.delegate = self
        refreshReceiptRequest?.start()
    }
    
    func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    
    func validateReceipt(data: Data, completion: @escaping (Date?, Bool?) -> Void) {
        var urlString = ""
        #if DEBUG
        urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
        #else
        urlString = "https://buy.itunes.apple.com/verifyReceipt"
        #endif
        
        var request = URLRequest.init(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let body = ["receipt-data": data.base64EncodedString(),
                    "password": "7c89a3ddc83a4728aaff8d604c92649a"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                let json = JSON(data as Any)
                
                guard let latestReceiptInfo = json["latest_receipt_info"].array?.last?.dictionary,
                    let expirationInfo = latestReceiptInfo["expires_date"]?.string,
                    let range = expirationInfo.range(of: "Etc")
                    else {
                        completion(nil, nil)
                        return
                }
                
                let expirationDateString = expirationInfo[..<range.lowerBound]  //substring(to: range.lowerBound)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
                let expirationDate = dateFormatter.date(from: String(expirationDateString))!
                let isTrial = latestReceiptInfo["is_trial_period"]?.boolValue
                completion(expirationDate, isTrial)
            }
            }.resume()
    }
}

// MARK: - SKProductsRequestDelegate

extension SubscriptionManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        for product in response.products {
            products[product.productIdentifier] = product
        }
        productsCallback?(response.products.sorted(by: { (product1, product2) -> Bool in
            return product1.price.intValue < product2.price.intValue
        }))
        productsRequest = nil
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKReceiptRefreshRequest {
            if refreshReceiptRequest != nil {
                refreshReceiptRequest = nil
                isSubscriptionActive = false
            }
        } else {
            productsRequest = nil
        }
    }
}


extension SubscriptionManager: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            checkSubscriptionStatus()
        }
    }
}

extension SubscriptionManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction)
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                SwiftLoader.hide()
                break
            case .failed:
                fail(transaction: transaction)
                SwiftLoader.hide()
                break
            case .restored:
                complete(transaction: transaction)
                SwiftLoader.hide()
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    func complete(transaction: SKPaymentTransaction) {
        isSubscriptionActive = true
        SKPaymentQueue.default().finishTransaction(transaction)
        let productId = transaction.payment.productIdentifier
        guard let product = products[productId] else { return }
        
         Analytics.logPurchase(productName: product.localizedTitle, price: product.price, currency: product.priceLocale.currencyCode ?? "")
    }
    
    
    
    func fail(transaction: SKPaymentTransaction) {
        UIAlertController.show(message: "Payment error".localized())
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension String {
    func localized(value: String? = nil) -> String {
        if let value = value {
            return String(format: NSLocalizedString(self, comment: ""), value)
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
}

extension Notification.Name {
    static let SubscriptionStatusNotification = Notification.Name("SubscriptionStatus")
}

public typealias UIAlertControllerActionHandler = (UIAlertAction) -> ()

public extension UIAlertController {
    
    static func show(title: String? = nil, message: String, actionButton: String = "OK", cancelButton: String? = nil, in vc: UIViewController? = nil, handler: UIAlertControllerActionHandler? = nil) {
        let alertController = UIAlertController.alertWithMessage(title: title, message: message, actionButton: actionButton, cancelButton: cancelButton, handler: handler)
        let presenter = vc ?? UIApplication.topViewController()
        presenter?.present(alertController, animated: true, completion: nil)
    }
}

extension UIAlertController {
    
    static func alertWithMessage(title: String? = nil, message: String, actionButton: String = "OK", cancelButton: String? = nil, handler: UIAlertControllerActionHandler? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if cancelButton != nil {
            let cancel = UIAlertAction(title: cancelButton, style: .destructive, handler: nil)
            alertController.addAction(cancel)
        }
        
        let action = UIAlertAction(title: actionButton, style: .default, handler: handler)
        alertController.addAction(action)
        
        return alertController
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

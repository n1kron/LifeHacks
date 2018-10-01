//
//  Created by Андрей Фоменко on 14.09.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit

class BuySubscriptionViewController: UIViewController {
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var restorePurchase: UIButton!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    var purchaseProducts = [SKProduct]()
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.addSubview(mainView)
        
        backView.layer.shadowRadius = 10.0
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        backView.layer.masksToBounds = false
        backView.layer.shadowOpacity = Float(10)
        
        buyButton.layer.shadowRadius = 2.0
        buyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        buyButton.layer.shadowColor = UIColor.black.cgColor
        buyButton.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        buyButton.layer.masksToBounds = false
        buyButton.layer.shadowOpacity = Float(10)
        
        SubscriptionManager.shared.requestProducts([SubscriptionManager.weekProductID]) { _ in
            let price = SubscriptionManager.localizedPrice(productId: SubscriptionManager.weekProductID)
            self.buyButton.setTitle("\(price) per week".localized(value: price), for: .normal)
        }
        
        loadProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(handleInAppPurchase(notification:)), name: .SubscriptionStatusNotification, object: nil)
        
        Analytics.logPurchaseScreenView(index: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        infoTextView.flashScrollIndicators()
        infoTextView.setContentOffset(.zero, animated: true)
    }
    
    @objc func handleInAppPurchase(notification: Notification) {
        guard let result = notification.object as? Bool else  { return }
        if result {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadProducts() {
        let productIds = [SubscriptionManager.weekProductID]
        SubscriptionManager.shared.requestProducts(productIds) { products in
            self.purchaseProducts = products
        }
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        SubscriptionManager.shared.resfreshReceipt()
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        SubscriptionManager.shared.buyProduct(id: SubscriptionManager.weekProductID)
    }
    
}

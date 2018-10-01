//
//  OnboardingViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 12.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit
import StoreKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var purchaseProducts = [SKProduct]()
    var contentViews = [UIView]()
    var currentX: CGFloat = 0
    var startTranslation : CGFloat = 0
    var numberActivePage = 1
    var divider : CGFloat = 300
    var coeffTransform : CGFloat = 2.8
    var originTop : CGFloat = -168.5
    var top : CGFloat = 50
    
    let textHeaderLabel = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["ВЫБИРАЙТЕ", "ЧИТАЙТЕ", "СЛЕДИТЕ"] : ["CHOOSE", "READ", "TRACK"]
    let textLitleLabel = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["Лайфхаки на любой вкус", "С смартфона в дороге или на планшете дома", "За подборками нашей редакции"] : ["Favorite life hacks", "With a iPhone on the road or on the iPad at home", "For the compilations of our editorial staff"]
    var textButton = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["ДАЛЕЕ", "ДАЛЕЕ", "НАЧАТЬ"] : ["NEXT", "NEXT", "START"]
    
    let countContentViews = 3
    let iphoneImageView = UIImageView(image: UIImage(named: "iphone"))
    let imageViewBackground = UIImageView(image: UIImage(named: "iphoneBackground"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // loadProducts()
       // NotificationCenter.default.addObserver(self, selector: #selector(handleInAppPurchase(notification:)), name: .SubscriptionStatusNotification, object: nil)
        
        contentScrollView.frame.size = CGSize(width: view.frame.width, height: contentScrollView.frame.height)
        if UIDevice.current.userInterfaceIdiom == .pad {
            iphoneImageView.frame.size = CGSize(width: 470, height: 800)
            imageViewBackground.frame = CGRect(x: 61, y: 121, width: 348, height: 557)
            divider = 500
            coeffTransform = 2.9
            originTop = -347
            top = 100
        } else {
            iphoneImageView.frame.size = CGSize(width: 215, height: 400)
            imageViewBackground.frame = CGRect(x: 28, y: 60.5, width: 159, height: 279)
        }
        iphoneImageView.center.x = view.center.x
        iphoneImageView.frame.origin.y = top
        view.addSubview(iphoneImageView)
        iphoneImageView.addSubview(imageViewBackground)
        addScrollView()
    }
    
//    func loadProducts() {
//        let productIds = [SubscriptionManager.weekProductID]
//        SubscriptionManager.shared.requestProducts(productIds) { products in
//            self.purchaseProducts = products
//        }
//    }
    
    @objc func handleInAppPurchase(notification: Notification) {
        guard let result = notification.object as? Bool else  { return }
        if result {
            let userDefaults = UserDefaults.standard
            userDefaults.set(1, forKey: "OnOnboarding")
            userDefaults.synchronize()
            performSegue(withIdentifier: "GoApp", sender: nil)
        }
    }
    
    func addScrollView() {
        contentScrollView.contentSize.width = contentScrollView.frame.size.width * CGFloat(countContentViews)
        
        let shadowPath = UIBezierPath(rect: CGRect(x: -contentScrollView.frame.width/2,
                                                   y: 0,
                                                   width: contentScrollView.contentSize.width + contentScrollView.frame.width,
                                                   height: contentScrollView.frame.height))
        contentScrollView.layer.shadowRadius = 20.0
        contentScrollView.layer.shadowColor = UIColor.white.cgColor
        contentScrollView.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(-50))
        contentScrollView.layer.masksToBounds = false
        contentScrollView.layer.shadowOpacity = 10
        contentScrollView.layer.shadowPath = shadowPath.cgPath
        for i in 0..<countContentViews {
            contentViews.append(createContentView(number: i))
            contentViews[i].frame.origin.x = currentX
            contentScrollView.addSubview(contentViews[i])
            currentX += contentScrollView.frame.size.width
        }
        view.addSubview(contentScrollView)
    }
    
    func createContentView(number: Int) -> UIView {
        let view = UIView()
        view.frame.size = contentScrollView.frame.size
        if UIDevice.current.userInterfaceIdiom != .pad {
            settings(number: number, multiplier: 1, view: view)
        } else {
            settings(number: number, multiplier: 2, view: view)
        }
        return view
    }
    
    func settings(number: Int, multiplier: CGFloat, view: UIView) {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30 * multiplier))
        settingsLabel(label: headerLabel, text: textHeaderLabel[number], nameFont: "HelveticaNeue-Bold", size: 27 * multiplier)
        view.addSubview(headerLabel)
        let litleLabel = UILabel(frame: CGRect(x: 20, y: headerLabel.frame.maxY, width: view.frame.width - 40, height: 30 * multiplier))
        settingsLabel(label: litleLabel, text: textLitleLabel[number], nameFont: "HelveticaNeue-Medium", size: 17 * multiplier)
        view.addSubview(litleLabel)
        var button = UIButton()
        if multiplier == 2 {
            button = UIButton(frame: CGRect(x: 100, y: (view.frame.maxY - litleLabel.frame.maxY) / 2 + litleLabel.frame.maxY, width: view.frame.width - 200, height: 100))
        } else {
            button = UIButton(frame: CGRect(x: 50, y: (view.frame.maxY - litleLabel.frame.maxY) / 2, width: view.frame.width - 100, height: 50))
        }
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20 * multiplier
        button.clipsToBounds = true
        button.setTitle(textButton[number], for: .normal)
        button.addTarget(self, action: #selector(touchButton(button:)), for: .touchUpInside)
        settingsLabel(label: button.titleLabel!, text: textButton[number], nameFont: "HelveticaNeue-Bold", size: 25 * multiplier)
        view.addSubview(button)
    }
    
    @objc func touchButton(button: UIButton) {
        if numberActivePage == 1 {
            numberActivePage = 2
            self.settingsAnimation(duration: 0.5,
                                   x: CGFloat(self.numberActivePage),
                                   y: CGFloat(self.numberActivePage),
                                   originY: top,
                                   contentOffsetX: 0)
            
        } else if numberActivePage == 2 {
            numberActivePage = 3
            self.settingsAnimation(duration: 0.5,
                                   x: coeffTransform,
                                   y: coeffTransform,
                                   originY: originTop,
                                   contentOffsetX: 0)
        } else {
            //if UserDefaults.standard.object(forKey: "check") as! Bool {
               // SubscriptionManager.shared.buyProduct(id: SubscriptionManager.weekProductID)
           // } else {
                let userDefaults = UserDefaults.standard
                userDefaults.set(1, forKey: "OnOnboarding")
                userDefaults.synchronize()
                performSegue(withIdentifier: "GoApp", sender: nil)
           // }
        }
    }
    
    func settingsLabel(label: UILabel, text: String, nameFont: String, size: CGFloat) {
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.textColor = .black
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        label.font = UIFont.init(name: nameFont, size: size)
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if iphoneImageView.transform.a >= 1 {
            if self.numberActivePage == 3 {
                if translation.x/divider > 0 {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: self.iphoneImageView.frame.minX - top + translation.x/3,
                                           contentOffsetX: translation.x)
                }
            } else if self.numberActivePage == 1 {
                if translation.x/divider < 0 {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: top,
                                           contentOffsetX: translation.x)
                }
            } else {
                if self.numberActivePage == 2 {
                    if translation.x < 0 {
                        self.settingsAnimation(duration: 0.1,
                                               x: CGFloat(self.numberActivePage)-translation.x/divider,
                                               y: CGFloat(self.numberActivePage)-translation.x/divider,
                                               originY: top+translation.x,
                                               contentOffsetX: translation.x)
                    } else {
                        self.settingsAnimation(duration: 0.1,
                                               x: CGFloat(self.numberActivePage)-translation.x/divider,
                                               y: CGFloat(self.numberActivePage)-translation.x/divider,
                                               originY: top,
                                               contentOffsetX: translation.x)
                    }
                } else {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: top,
                                           contentOffsetX: translation.x)
                }
            }
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            if contentScrollView.contentOffset.x - contentScrollView.frame.width * CGFloat(numberActivePage - 1) > contentScrollView.frame.width / 3 {
                numberActivePage += 1
                if numberActivePage < 3 {
                    self.settingsAnimation(duration: 0.5,
                                           x: CGFloat(self.numberActivePage),
                                           y: CGFloat(self.numberActivePage),
                                           originY: top,
                                           contentOffsetX: 0)
                } else {
                    self.settingsAnimation(duration: 0.5,
                                           x: coeffTransform,
                                           y: coeffTransform,
                                           originY: originTop,
                                           contentOffsetX: 0)
                }
            } else if contentScrollView.contentOffset.x - contentScrollView.frame.width * CGFloat(numberActivePage - 1) < -(contentScrollView.frame.width) / 3 && numberActivePage > 1 {
                numberActivePage -= 1
                self.settingsAnimation(duration: 0.5,
                                       x: CGFloat(self.numberActivePage),
                                       y: CGFloat(self.numberActivePage),
                                       originY: top,
                                       contentOffsetX: 0)
            } else {
                if self.numberActivePage == 3 {
                    self.settingsAnimation(duration: 0.5,
                                           x: coeffTransform,
                                           y: coeffTransform,
                                           originY: originTop,
                                           contentOffsetX: 0)
                } else {
                    self.settingsAnimation(duration: 0.5,
                                           x: CGFloat(self.numberActivePage),
                                           y: CGFloat(self.numberActivePage),
                                           originY: top,
                                           contentOffsetX: 0)
                }
            }
        }
    }
    
    func settingsAnimation(duration: CGFloat, x: CGFloat, y: CGFloat, originY: CGFloat, contentOffsetX: CGFloat) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.iphoneImageView.transform = CGAffineTransform(scaleX: x, y: y)
                        self.iphoneImageView.frame.origin.y = originY
                        self.contentScrollView.contentOffset.x = self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1) - contentOffsetX
        }, completion: nil)
    }
}

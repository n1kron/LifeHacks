//
//  OnboardingViewController.swift
//  Wallpaper
//
//  Created by Андрей Фоменко on 04.09.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
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
    var divider : CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 500 : 400
    var coeffTransform : CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3.3 : 2.8
    var originTop : CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? -270 : -130
    var top : CGFloat = 50
    var buttonPurchase = UIButton()
    
    let textView = UITextView()
    let countContentViews = 3
    let textHeaderLabel = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["Следите", "Читайте", "Следите"] : ["Track", "Read", "Track"]
    let textLitleLabel = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["за подборками нашей редакции", "c смартфона в дороге или на планшете дома", "за подборками нашей редакции"] : ["for the compilations of our editorial staff", "with a iPhone on the road or on the iPad at home", "for the compilations of our editorial staff"]
    var textButton = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? ["Далее", "Далее", "Начать"] : ["Next", "Next", "Start"]
    let iphoneImageView = UIView()
    let imageViewBackground = UIImageView(image: UIImage(named: "Image0"))
    let imageViewBackground1 = UIImageView(image: UIImage(named: "Image2"))
    let imageViewBackground2 = UIImageView(image: UIImage(named: "Image1"))
    let imageViewIphone = UIImageView(image: UIImage(named: "iphone"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        
        SubscriptionManager.shared.requestProducts([SubscriptionManager.weekProductID]) { _ in
            let price = SubscriptionManager.localizedPrice(productId: SubscriptionManager.weekProductID)
            self.buttonPurchase.setTitle(Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? "3 дня бесплатно, после \(price) в неделю" : "3 days free after \(price) per week".localized(value: price), for: .normal)
            self.textView.text = "Install the app and start Premium subscription and get 3 days of free use. After that — Premium subscription will cost only \(price) per week.\n\nIf you choose to buy Premium subscription, payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.\n\nTerms of use: http://lifehacks.website/tos.html\nPrivacy policy: http://lifehacks.website/tos2.html"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInAppPurchase(notification:)), name: .SubscriptionStatusNotification, object: nil)
        
        Analytics.logPurchaseScreenView(index: 1)
        contentScrollView.isPagingEnabled = true
        contentScrollView.scrollsToTop = false
        contentScrollView.delegate = self
        contentScrollView.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: view.frame.height / 2)
        contentScrollView.contentSize.width = contentScrollView.frame.size.width * CGFloat(countContentViews)
        if UIDevice.current.userInterfaceIdiom == .pad {
            iphoneImageView.frame.size = CGSize(width: 480, height: 800)
            imageViewBackground.frame = CGRect(x: 81, y: 55, width: 320, height: 690)
            imageViewBackground1.frame = CGRect(x: 81, y: 55, width: 320, height: 690)
            imageViewBackground2.frame = CGRect(x: 81, y: 55, width: 320, height: 690)
        } else {
            iphoneImageView.frame.size = CGSize(width: 240, height: 400)
            imageViewBackground.frame = CGRect(x: 40.5, y: 27.5, width: 159, height: 345)
            imageViewBackground1.frame = CGRect(x: 40.5, y: 27.5, width: 159, height: 345)
            imageViewBackground2.frame = CGRect(x: 40.5, y: 27.5, width: 159, height: 345)
        }
        iphoneImageView.center.x = view.center.x
        iphoneImageView.frame.origin.y = top
        imageViewIphone.frame.size = iphoneImageView.frame.size
        iphoneImageView.addSubview(imageViewBackground2)
        iphoneImageView.addSubview(imageViewBackground1)
        iphoneImageView.addSubview(imageViewBackground)
        iphoneImageView.addSubview(imageViewIphone)
        view.addSubview(iphoneImageView)
        addScrollView()
    }
    
    func addScrollView() {
        let shadowPath = UIBezierPath(rect: CGRect(x: -contentScrollView.frame.width/2,
                                                   y: 0,
                                                   width: contentScrollView.contentSize.width + contentScrollView.frame.width,
                                                   height: contentScrollView.frame.height))
        contentScrollView.layer.shadowRadius = 20.0
        contentScrollView.layer.shadowColor = UIColor.init(red: 15/255, green: 15/255, blue: 15/255, alpha: 1).cgColor
        contentScrollView.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(-50))
        contentScrollView.layer.masksToBounds = false
        contentScrollView.layer.shadowOpacity = Float(10)
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
        if number == 2 {
            if UIDevice.current.userInterfaceIdiom != .pad {
                settingPurchaseView(number: number, multiplier: 1, view: view)
            } else {
                settingPurchaseView(number: number, multiplier: 2, view: view)
            }
        } else {
            if UIDevice.current.userInterfaceIdiom != .pad {
                settings(number: number, multiplier: 1, view: view)
            } else {
                settings(number: number, multiplier: 2, view: view)
            }
        }
        return view
    }
    
    func settings(number: Int, multiplier: CGFloat, view: UIView) {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: -30 * multiplier, width: view.frame.width, height: 50 * multiplier))
        settingsLabel(label: headerLabel, text: textHeaderLabel[number], nameFont: "Cochin-Bold", size: 35 * multiplier, color: .white)
        headerLabel.frame.size.width = view.frame.width
        view.addSubview(headerLabel)
        let litleLabel = UILabel(frame: CGRect(x: 0, y: headerLabel.frame.maxY + 10, width: view.frame.width, height: 80 * multiplier))
        settingsLabel(label: litleLabel, text: textLitleLabel[number], nameFont: "Cochin-Bold", size: 25 * multiplier, color: .white)
        litleLabel.frame.size.width = view.frame.width
        view.addSubview(litleLabel)
        var button = UIButton()
        if multiplier == 2 {
            button = UIButton(frame: CGRect(x: 100, y: view.frame.maxY - 200 , width: view.frame.width - 200, height: 100))
        } else {
            button = UIButton(frame: CGRect(x: 30, y: view.frame.maxY - 100, width: view.frame.width - 60, height: 50))
        }
        let colorTop =  UIColor(red: 38.0/255.0, green: 89.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        button.backgroundColor = colorTop
        button.layer.cornerRadius = 5 * multiplier
        button.setTitle(textButton[number], for: .normal)
        button.layer.shadowColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(touchButton(button:)), for: .touchUpInside)
        settingsLabel(label: button.titleLabel!, text: textButton[number], nameFont: "Cochin-Bold", size: 35 * multiplier, color: .white)
        button.setTitleColor(.white, for: .normal)
        view.addSubview(button)
    }
    
    func settingPurchaseView(number: Int, multiplier: CGFloat, view: UIView) {
        textView.isUserInteractionEnabled = true
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.text = "Install the app and start Premium subscription and get 3 days of free use. After that — Premium subscription will cost only $9.99 USD per week.\n\nIf you choose to buy Premium subscription, payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.\n\nTerms of use: http://lifehacks.website/tos.html\nPrivacy policy: http://lifehacks.website/tos2.html"
        textView.font = UIFont.init(name: "Cochin", size: 12 * multiplier)
        textView.textAlignment = .justified
        textView.backgroundColor = .clear
        textView.textColor = .white
        print(contentScrollView.frame.height)
        textView.frame = CGRect(x: 5, y: contentScrollView.frame.height - 240 * multiplier, width: view.frame.width - 10, height: 220 * multiplier)
        view.addSubview(textView)
        
        if multiplier == 2 {
            buttonPurchase = UIButton(frame: CGRect(x: 100, y: textView.frame.minY - 120 , width: view.frame.width - 200, height: 100))
        } else {
            buttonPurchase = UIButton(frame: CGRect(x: 30, y: textView.frame.minY - 60, width: view.frame.width - 60, height: 50))
        }
        let colorTop =  UIColor(red: 38.0/255.0, green: 89.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        buttonPurchase.backgroundColor = colorTop
        buttonPurchase.layer.cornerRadius = 5 * multiplier
        buttonPurchase.setTitle(Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? "3 дня бесплатно, после 799₽ в неделю" : "3 days free after 9.99$ per week" , for: .normal)
        buttonPurchase.layer.shadowColor = UIColor.white.cgColor
        buttonPurchase.addTarget(self, action: #selector(touchButton(button:)), for: .touchUpInside)
        settingsLabel(label: buttonPurchase.titleLabel!, text: textButton[number], nameFont: "Cochin-Bold", size: 20 * multiplier, color: .white)
        buttonPurchase.setTitleColor(.white, for: .normal)
        view.addSubview(buttonPurchase)
        
        let litleLabel = UILabel(frame: CGRect(x: 0, y: buttonPurchase.frame.minY - 80 * multiplier, width: view.frame.width, height: 80 * multiplier))
        var text =  Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? "☆ ко всем лайфхакам в приложении \n☆ ко всем самым новым лайфхакам" : "☆  to all lifehacks in the application\n☆  to the newest lifehacks"
        settingsLabel(label: litleLabel, text: text, nameFont: "Cochin-Bold", size: 20 * multiplier, color: .white)
        litleLabel.frame.size.width = view.frame.width
        view.addSubview(litleLabel)
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: litleLabel.frame.minY - 60 * multiplier, width: view.frame.width, height: 50 * multiplier))
        text = Utiles().getPrefferedLocale() == Locale(identifier: "ru-US") ? "Вы получите доступ" : "You will get access"
        settingsLabel(label: headerLabel, text: text, nameFont: "Cochin-Bold", size: 35 * multiplier, color: .white)
        headerLabel.frame.size.width = view.frame.width
        view.addSubview(headerLabel)
    }
    
    @objc func touchButton(button: UIButton) {
        if numberActivePage == 1 {
            numberActivePage = 2
            self.settingsAnimation(duration: 0.5,
                                   x: CGFloat(self.numberActivePage),
                                   y: CGFloat(self.numberActivePage),
                                   originY: top,
                                   contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
            settingAlpha(duration: 0.5, imageView: imageViewBackground, alpha: 0)
            
        } else if numberActivePage == 2 {
            numberActivePage = 3
            self.settingsAnimation(duration: 0.5,
                                   x: coeffTransform,
                                   y: coeffTransform,
                                   originY: originTop,
                                   contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
            settingAlpha(duration: 0.5, imageView: imageViewBackground1, alpha: 0)
        } else {
            if SubscriptionManager.shared.isSubscriptionActive != true {
                SubscriptionManager.shared.buyProduct(id: SubscriptionManager.weekProductID)
            } else {
                let userDefaults = UserDefaults.standard
                userDefaults.set(1, forKey: "OnOnboarding")
                userDefaults.synchronize()
                performSegue(withIdentifier: "GoApp", sender: nil)
            }
        }
    }
    
    func loadProducts() {
        let productIds = [SubscriptionManager.weekProductID]
        SubscriptionManager.shared.requestProducts(productIds) { products in
            self.purchaseProducts = products
        }
    }
    
    @objc func handleInAppPurchase(notification: Notification) {
        guard let result = notification.object as? Bool else  { return }
        if result {
            let userDefaults = UserDefaults.standard
            userDefaults.set(1, forKey: "OnOnboarding")
            userDefaults.synchronize()
            performSegue(withIdentifier: "GoApp", sender: nil)
        }
    }
    
    func settingsLabel(label: UILabel, text: String, nameFont: String, size: CGFloat, color: UIColor) {
        label.textColor = color
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 2, height: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 1.0
        label.clipsToBounds = false
        label.font = UIFont.init(name: nameFont, size: size)
        label.sizeToFit()
        label.textAlignment = .center
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if iphoneImageView.transform.a >= 1 {
            if self.numberActivePage == 3 {
                if translation.x/divider > 0 {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: self.iphoneImageView.frame.minX + translation.x/4 + 26,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1)-translation.x)
                    settingAlpha(duration: 0.1, imageView: imageViewBackground1, alpha: translation.x/self.divider * 1.5)
                }
            } else if self.numberActivePage == 1 {
                if translation.x/divider < 0 {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: top,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1)-translation.x)
                    settingAlpha(duration: 0.1, imageView: imageViewBackground, alpha: 1 + translation.x/self.divider * 1.5)
                }
            } else {
                if self.numberActivePage == 2 {
                    if translation.x < 0 {
                        self.settingsAnimation(duration: 0.1,
                                               x: CGFloat(self.numberActivePage)-translation.x/divider,
                                               y: CGFloat(self.numberActivePage)-translation.x/divider,
                                               originY: top+translation.x/2,
                                               contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1)-translation.x)
                        settingAlpha(duration: 0.1, imageView: imageViewBackground1, alpha: 1 + translation.x/self.divider * 1.5)
                    } else {
                        self.settingsAnimation(duration: 0.1,
                                               x: CGFloat(self.numberActivePage)-translation.x/divider,
                                               y: CGFloat(self.numberActivePage)-translation.x/divider,
                                               originY: top,
                                               contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1)-translation.x)
                        settingAlpha(duration: 0.1, imageView: imageViewBackground, alpha: translation.x/self.divider * 1.5)
                    }
                } else {
                    self.settingsAnimation(duration: 0.1,
                                           x: CGFloat(self.numberActivePage)-translation.x/divider,
                                           y: CGFloat(self.numberActivePage)-translation.x/divider,
                                           originY: top,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1)-translation.x)
                }
            }
        }
        if recognizer.state == UIGestureRecognizer.State.ended {
            if contentScrollView.contentOffset.x - contentScrollView.frame.width * CGFloat(numberActivePage - 1) > contentScrollView.frame.width / 3 && numberActivePage < 3 {
                numberActivePage += 1
                if numberActivePage < 3 {
                    self.settingsAnimation(duration: 0.5,
                                           x: CGFloat(self.numberActivePage),
                                           y: CGFloat(self.numberActivePage),
                                           originY: top,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
                    settingAlpha(duration: 0.5, imageView: imageViewBackground, alpha: 0)
                } else {
                    self.settingsAnimation(duration: 0.5,
                                           x: coeffTransform,
                                           y: coeffTransform,
                                           originY: originTop,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
                    settingAlpha(duration: 0.5, imageView: imageViewBackground1, alpha: 0)
                }
            } else if contentScrollView.contentOffset.x - contentScrollView.frame.width * CGFloat(numberActivePage - 1) < -(contentScrollView.frame.width) / 3 && numberActivePage > 1 {
                numberActivePage -= 1
                self.settingsAnimation(duration: 0.5,
                                       x: CGFloat(self.numberActivePage),
                                       y: CGFloat(self.numberActivePage),
                                       originY: top,
                                       contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
                if numberActivePage == 1 {
                    settingAlpha(duration: 0.5, imageView: imageViewBackground, alpha: 1)
                } else {
                    settingAlpha(duration: 0.5, imageView: imageViewBackground1, alpha: 1)
                }
            } else {
                if self.numberActivePage == 3 {
                    self.settingsAnimation(duration: 0.5,
                                           x: coeffTransform,
                                           y: coeffTransform,
                                           originY: originTop,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
                    settingAlpha(duration: 0.5, imageView: imageViewBackground1, alpha: 0)
                } else {
                    self.settingsAnimation(duration: 0.5,
                                           x: CGFloat(self.numberActivePage),
                                           y: CGFloat(self.numberActivePage),
                                           originY: top,
                                           contentOffsetX: self.contentScrollView.frame.width * CGFloat(self.numberActivePage-1))
                    if numberActivePage == 1 {
                        settingAlpha(duration: 0.5, imageView: imageViewBackground, alpha: 1)
                    } else {
                        settingAlpha(duration: 0.5, imageView: imageViewBackground, alpha: 0)
                        settingAlpha(duration: 0.5, imageView: imageViewBackground1, alpha: 1)
                    }
                }
            }
        }
    }
    
    func settingsAnimation(duration: CGFloat, x: CGFloat, y: CGFloat, originY: CGFloat, contentOffsetX: CGFloat) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.iphoneImageView.transform = CGAffineTransform(scaleX: x, y: y)
                        self.iphoneImageView.frame.origin.y = originY
                        self.contentScrollView.contentOffset.x = contentOffsetX
                        
        }, completion: nil)
    }
    
    func settingAlpha(duration: CGFloat, imageView: UIImageView, alpha: CGFloat) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        imageView.alpha = alpha
        }, completion: nil)
    }
}

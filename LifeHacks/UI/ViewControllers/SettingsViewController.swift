//
//  SettingsViewController.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    @IBOutlet var settingsButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in settingsButtons {
            button.layer.cornerRadius = 10
        }
    }
    
    @IBAction func rateAction(_ sender: Any) {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        } else {
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/life-hacks/id1436207860?l=ru&ls=1&mt=8")!, options: [:], completionHandler: nil) // update this
        }
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        openUrl(urlString: "http://104.236.106.86/politics.html") // change reference
    }
    
    @IBAction func termOfUseAction(_ sender: Any) {
        openUrl(urlString: "http://104.236.106.86/po.html") // change reference
    }
    
    @IBAction func subscriptionAgreementAction(_ sender: Any) {
        openUrl(urlString: "http://104.236.106.86/politics.html") // change reference
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

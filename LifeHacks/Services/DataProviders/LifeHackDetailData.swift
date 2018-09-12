//
//  LifeHackDetailData.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import Foundation
import Alamofire

class LifeHackDetailData {
    var lifeHacksSteps: [LifeHackDetail] = []
    static let shared = LifeHackDetailData()
    
    func getData(id: String) {
        Alamofire.request("http://lifehacks.website/lifehacks/items/\(id)").responseJSON { [weak self] (response) in
            self?.lifeHacksSteps.removeAll()
            if let unparsedLifeHacks = response.result.value as? [String: Any] {
                if let steps = unparsedLifeHacks["steps"] as? [[String: Any]] {
                    for lifeHack in steps {
                        let lifeHackList: LifeHackDetail = LifeHackDetail(dict:lifeHack)
                        self?.lifeHacksSteps.append(lifeHackList)
                    }
                    NotificationCenter.default.post(name: Notification.Name("steps"), object: nil)
                }
            }
        }
    }
}

//
//  LifeHacksData.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 06.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import Foundation
import Alamofire

class LifeHacksData {
    var lifeHacksList: [LifeHack] = []
    var newList: [String] = []
    static let shared = LifeHacksData()
    
    func getData() {
        Alamofire.request("http://lifehacks.website/lifehacks/items").responseJSON { [weak self] (response) in
            if let unparsedLifeHacks = response.result.value as? [[String: Any]] {
                for lifeHack in unparsedLifeHacks {
                    let lifeHackList: LifeHack = LifeHack(dict: lifeHack)
                    self?.newList.append(lifeHackList.id)
                    self?.lifeHacksList.append(lifeHackList)
                }
                NotificationCenter.default.post(name: Notification.Name("hacks"), object: nil)
            }
        }
    }
}

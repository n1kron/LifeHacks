//
//  LifeHack.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 06.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import Foundation

class LifeHack: NSObject {
    let id: String
    let title: String
    let image: String
    
    init(dict: [String: Any]) {
        title = dict["full_title"] as? String ?? ""
        image = dict["image"] as? String ?? ""
        id = dict["id"] as? String ?? ""
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? LifeHack)?.id
    }
}

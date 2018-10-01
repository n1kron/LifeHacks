//
//  LifeHackStep.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 07.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import Foundation

class LifeHackDetail {
    let text: String
    let images: [String]
    
    init(dict: [String: Any]) {
        text = dict["text"] as? String ?? ""
        images = dict["images"] as? [String] ?? []
    }
}

//
//  Utiles.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 13.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class Utiles {
    static func delay(time: TimeInterval, action: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            action()
        }
    }
}

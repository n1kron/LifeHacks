//
//  Consts.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class Consts {
    static let isIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    struct goldPlace {
        static let firstHack = "Replace-Flap-on-Phone-Case"
        static let secondHack = "Wooden-Broken-Straight-Sword-DS3"
        static let thirdHack = "Simple-Modern-Writing-Desk"
        
        static let all = [firstHack, secondHack, thirdHack]
    }
    
    struct silverPlace {
        static let firstHack = "Poured-Resin-Coffee-Table"
        static let secondHack = "Fix-a-Cracked-Bucket"
        static let thirdHack = "Repair-a-Blender"
        static let fourthHack = "Make-a-Sign-With-the-Shopbot-Cnc-Router"
        static let fifthHack = "Childrens-house-Bed-Frame"
        
        static let all = [firstHack, secondHack, thirdHack, fourthHack, fifthHack]
    }
}

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
        static let firstHack = "Reclaimed-Wall-Map-With-Epoxy-Resin-River-and-Road"
        static let secondHack = "Wooden-Broken-Straight-Sword-DS3"
        static let thirdHack = "Simple-Modern-Writing-Desk"
        
        static let all = [firstHack, secondHack, thirdHack]
    }
    
    struct silverPlace {
        static let firstHack = "Floating-Shelf-With-Mountains"
        static let secondHack = "How-to-Make-a-Guitar-Pickguard"
        static let thirdHack = "Repair-a-Blender"
        static let fourthHack = "Wood-Resin-Turtles"
        static let fifthHack = "Vintage-Biplane-Shelf"
        
        static let all = [firstHack, secondHack, thirdHack, fourthHack, fifthHack]
    }
}

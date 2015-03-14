//
//  MrBlack.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-14.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Darwin



class MrBlack {
    
    var GS:GameScene = GameScene()
    
    class func starship2Move() {
        Game.🚀2.setSpeed(CGPoint(x: -25, y: -25))
        println(Game.🚀2.sprite)
    }
}
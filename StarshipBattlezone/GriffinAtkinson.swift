//
//  GriffinAtkinson.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-15.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Darwin

class GriffinAtkinson: NSObject, gameSceneDelegate {
    
    func starship1Move() {
        Game.🚀1.setSpeed(CGPoint(x: 0, y: 0))
        Game.🚀1.move()
    }
    
    func starship2Move() {
        Game.🚀2.setSpeed(CGPoint(x: 0, y: 0))
        Game.🚀2.move()
    }
}
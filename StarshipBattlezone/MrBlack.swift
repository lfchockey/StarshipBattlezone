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


class MrBlack: gameSceneDelegate {
    //override var description : String {return "I am a Mr. Black"}
    
    var counter = 0 // Counts the number of times the update function has run
    
    func starship1Move() {
        counter++
        
        if counter < 100 {
            Game.🚀1.setSpeed(CGPoint(x: 25, y: 25))
        }
        else if counter < 200 {
            Game.🚀1.setSpeed(CGPoint(x: -25, y: 25))
        }
        else if counter < 300 {
            Game.🚀1.setSpeed(CGPoint(x: -25, y: -25))
        }
        else if counter < 400 {
            Game.🚀1.setSpeed(CGPoint(x: 25, y: -25))
        }
        else {
            counter = 0
        }
        
        Game.🚀1.move()
        
        if counter % 10 == 0 {
            Game.🚀1.fire(CGPoint(x: ((Game.🚀2.sprite.position.x - Game.🚀1.sprite.position.x)/5), y: (Game.🚀2.sprite.position.y - Game.🚀1.sprite.position.y)/5))
        }
        
    }
    
    func starship2Move() {
        Game.🚀2.setSpeed(CGPoint(x: 0, y: 0))
        Game.🚀2.move()
    }
}
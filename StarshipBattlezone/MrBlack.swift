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
        counter++   // Increment the counter.
        
        // Depending on the counter, loop through and change the speed/direction of the StarShip.
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
        
        // Set up variables that find the other StarShip's position and speed as well as your own.
        //      These are used inside calculations.
        var otherStarShipSpeed = Game.🚀2.getSpeed()
        var otherStarShipPosition = Game.🚀2.getPosition()
        var yourStarShipSpeed = Game.🚀1.getSpeed()
        var yourStarShipPosition = Game.🚀1.getPosition()
        
        if counter % 10 == 0 {
            // This is an awful shooting algorithm that shoots where the other StarShip is (not where he's going to be)
            Game.🚀1.fire(CGPoint(x: ((otherStarShipPosition.x - yourStarShipPosition.x)/5), y: (otherStarShipPosition.y - yourStarShipPosition.y)/5))
        }
        
    }
    
    
    // This is the function that is called inside the update function in the GameScene
    //      (every instant before a frame is displayed).
    func starship2Move() {
        
        var randomHorizontalSpeed: Int = 0 // Create a random variable to set the horizontal speed of the Starship
        
        if counter < 100 {
            randomHorizontalSpeed = Int(arc4random_uniform(UInt32(25) + 1))
            Game.🚀2.setSpeed(CGPoint(x: randomHorizontalSpeed, y: 25))
        }
        else if counter < 200 {
            Game.🚀2.setSpeed(CGPoint(x: -25, y: 25))
        }
        else if counter < 300 {
            Game.🚀2.setSpeed(CGPoint(x: -25, y: -25))
        }
        else if counter < 400 {
            Game.🚀2.setSpeed(CGPoint(x: 25, y: -25))
        }

        Game.🚀2.move()
    }
}
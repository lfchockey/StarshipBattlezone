//
//  Starship.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//


import Foundation
import UIKit
import SpriteKit
import Darwin

class Starship {
    // Declare properties of a Starship
    var speed = CGPoint(x: 0, y: 0)
    var sprite = SKSpriteNode()
    var texture = SKTexture()
    var viewSize = CGPoint()    // width, height
    var missiles: [Missile] = []
    var missileNumber = 0
    let TOTAL_MISSILES = 10
    var life = 20
    var name = ""
    var playerNumber = 0
    
    // Constructor
    init(playerNum: Int) {
        
//        sprite = SKSpriteNode(imageNamed:"Star.png")
//        
//        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Star.png"), size: sprite.size)
//        if let physics = sprite.physicsBody {
//            physics.affectedByGravity = false
//            physics.allowsRotation = true
//        }

        self.sprite.xScale = 0.1
        self.sprite.yScale = 0.1
        self.sprite.zRotation = CGFloat(M_PI)
                
        // Initialize all of the missile objects
        for i in 0..<TOTAL_MISSILES {
            let missile = Missile()
            //missile.viewSize = self.viewSize // this isn't initialized until later
            missiles.append(missile)
            //self.sprite.addChild(missile.sprite)
        }
        
        // Position the tanks based on whether they are Player1 or Player2
        self.playerNumber = playerNum
        //println(Game.🚀1.sprite)

    }
    
    func setSprite(filename: String) {
        sprite = SKSpriteNode(imageNamed: filename)
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: filename), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = true
        }
        if self.playerNumber == 1 {
            self.sprite.position.x = self.viewSize.x/2
            self.sprite.position.y = 100
        }
        else {
            self.sprite.position.x = self.viewSize.x/2
            self.sprite.position.y = self.viewSize.y - 100
            
        }

        //println(Game.🚀1.sprite)
      
    }
    
    func getSpeed() -> CGPoint {
        return self.speed
    }
    
    func setSpeed(newSpeed: CGPoint) {
        var spd = CGPoint(x: newSpeed.x, y: newSpeed.y)
        
        if newSpeed.x > 10 {
            spd = CGPoint (x: 10, y: newSpeed.y)
        }
        else if newSpeed.x < -10 {
            spd = CGPoint (x: -10, y: newSpeed.y)
        }
        else {
            spd = CGPoint (x: spd.x, y: newSpeed.y)
        }
        
        
        if newSpeed.y > 10 {
            spd = CGPoint (x: spd.x, y: 10)
        }
        else if newSpeed.x < -10 {
            spd = CGPoint (x: spd.x, y: -10)
        }
        else {
            spd = CGPoint (x: spd.x, y: newSpeed.y)
        }
        
        self.speed = spd
    }
    
    func move (){
        self.sprite.physicsBody?.velocity = CGVector(dx: self.speed.x, dy: self.speed.y)
    }
    
    func fire (missileSpeed: CGPoint) -> Void {
        for var i = self.missileNumber; i < self.TOTAL_MISSILES; i++ {
            if !missiles[i].isBeingFired {
                missiles[i].setSpeed(missileSpeed, newPosition: self.sprite.position)
                missiles[i].isBeingFired = true
                break
            }
        }
        
        missileNumber++
        if missileNumber >= TOTAL_MISSILES {
            missileNumber = 0
        }
    }
    
    func getWidth() -> CGFloat {
        return sprite.size.width
    }
    
    func getHeight() -> CGFloat {
        return sprite.size.height
    }
    
}
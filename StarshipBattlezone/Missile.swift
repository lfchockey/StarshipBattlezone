//
//  Missile.swift
//  TestGame
//
//  Created by SFDCI on 2015-03-03.
//  Copyright (c) 2015 SFDCI. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Darwin


class Missile {
    var speed = CGPoint(x: 0, y: 0)
    var sprite = SKSpriteNode()
    var texture = SKTexture()
    var viewSize = CGPoint()    // width, height
    var starshipSize = CGSize()
    var isBeingFired = false
    var angle: Float = 0.0
    var playerNumber = 0
    var missileAnimation = [SKTexture]()
    
    init (playerNum: Int) {
        sprite = SKSpriteNode(imageNamed:"Missile1")
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
       
        self.playerNumber = playerNum
        
    }
    
    func setSprite(num: Int) {
     
        //sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Missile1"), size: sprite.size)
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.frame.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.linearDamping = 0.0
            physics.angularDamping = 0.0
            physics.usesPreciseCollisionDetection = true
            if playerNumber == 1 {
                physics.categoryBitMask =  ColliderType.Missile1.rawValue //Game.missile1Category
                physics.collisionBitMask = ColliderType.Starship2.rawValue //Game.starship2Category //| Game.missile2Category //ColliderType.Starship2.rawValue | ColliderType.Missile2.rawValue
                physics.contactTestBitMask = ColliderType.Starship2.rawValue //ColliderType.Missile1.rawValue
                sprite.zRotation = CGFloat(M_PI)
                sprite.name = String("Missile1-\(num)")
            }
            else {
                physics.categoryBitMask = ColliderType.Missile2.rawValue //Game.missile2Category
                physics.collisionBitMask = ColliderType.Starship1.rawValue  //Game.starship1Category | Game.missile1Category //ColliderType.Starship1.rawValue | ColliderType.Missile1.rawValue
                physics.contactTestBitMask = ColliderType.Starship1.rawValue  //ColliderType.Missile2.rawValue
                sprite.zRotation = CGFloat(M_PI)
                sprite.name = String("Missile2-\(num)")
            }
        }
        //self.sprite.position = CGPoint(x: 100 + num * 100 , y: 200)
        self.sprite.position = CGPoint(x: -50, y: -50)
        let missileAtlas = SKTextureAtlas(named: "Missiles")
        
        for index in 1...missileAtlas.textureNames.count {
            let texture = "Missile\(index)"
            missileAnimation += [missileAtlas.textureNamed(texture)]
        }
        
        for i in 0..<10 {
            let animate = SKAction.animateWithTextures(missileAnimation, timePerFrame: 0.05)
            sprite.runAction(SKAction.repeatActionForever(animate))
        }
    }

    func setSpeed (newSpeed: CGPoint, newPosition: CGPoint) {
    
        
        var tempSpeedX = newSpeed.x
        var tempSpeedY = newSpeed.y
        
        if newSpeed.x > 100 {
            tempSpeedX = 100
        }
        else if newSpeed.x < -100 {
            tempSpeedX = -100
        }
        
        if newSpeed.y > 100 {
            tempSpeedY = 100
        }
        else if newSpeed.y < -100 {
            tempSpeedY = -100
        }
        
        self.speed = CGPoint(x: tempSpeedX, y: tempSpeedY)
        

        angle = atan2f(Float(tempSpeedY), Float(tempSpeedX))
//        angle = angle - Float(M_PI/2)
        //println(angle)
        //self.sprite.zRotation = CGFloat(angle)
        self.sprite.zRotation = CGFloat(angle)
        self.sprite.position = newPosition
        self.sprite.physicsBody?.velocity = CGVector(dx: self.speed.x, dy: self.speed.y)
    }
    
    
    func move() {
        if (self.isBeingFired) {
            //  Check to see if bullet goes off the View
            //println("XSprite \(sprite.position.x) - XView \(viewSize.x) - YSprite \(sprite.position.y) - YView \(viewSize.y)")
            if (self.sprite.position.x < 0 || self.sprite.position.x > self.viewSize.x || self.sprite.position.y < 0 || self.sprite.position.y > self.viewSize.y) {
                self.isBeingFired = false
                self.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.sprite.position = CGPoint(x: -50, y: -50)
                var moveMissile = SKAction.moveTo(self.sprite.position, duration: 0.01)
                var moveAction = SKAction.repeatAction(moveMissile, count: 1)
                sprite.runAction(moveAction)
            }
        }
    }
    
}
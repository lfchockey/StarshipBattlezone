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
    var gun = SKNode()
    var missiles: [Missile] = []
    var missileNumber = 0
    let TOTAL_MISSILES = 10
    var life = 20
    var name = ""
    var imageName = ""
    var playerNumber = 0
    var angle: Float = 0.0
    
    
    // Constructor
    init(playerNum: Int) {
        
        // Set the player number of each Starship
        self.playerNumber = playerNum
        
        // Initialize all of the missile objects
        for i in 0..<TOTAL_MISSILES {
            let missile = Missile(playerNum: playerNum)
            missiles.append(missile)
        }
    }
    
    func setSprite(filename: String) {

        sprite = SKSpriteNode(imageNamed: imageName)            
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: sprite.size) // hard-coding this line with a cgsize makes the missiles fly?
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = true
            physics.usesPreciseCollisionDetection = true
            if playerNumber == 1 {
                physics.categoryBitMask =  ColliderType.Starship1.rawValue //Game.starship1Category
                physics.collisionBitMask = ColliderType.Missile2.rawValue | ColliderType.Starship2.rawValue //Game.missile2Category
                physics.contactTestBitMask = ColliderType.Missile2.rawValue //Game.starship2Category //ColliderType.Starship2.rawValue
            }
            else {
                physics.categoryBitMask = ColliderType.Starship2.rawValue //Game.starship2Category
                physics.collisionBitMask = ColliderType.Missile1.rawValue | ColliderType.Starship1.rawValue //Game.missile1Category
                physics.contactTestBitMask = ColliderType.Missile1.rawValue //Game.starship1Category //ColliderType.Starship1.rawValue
            }
        }
        //println("\(ColliderType.Starship1.rawValue) - \(ColliderType.Starship2.rawValue)")
        //println(sprite.physicsBody?.categoryBitMask)
        //println(Game.starship1Category)
        //println(Game.missile1Category)
        
        if self.playerNumber == 1 {
            self.sprite.position.x = self.viewSize.x/2
            self.sprite.position.y = 100
            self.sprite.name = "Starship1"
        }
        else {
            self.sprite.position.x = self.viewSize.x/2
            self.sprite.position.y = self.viewSize.y - 100
            self.sprite.zRotation = CGFloat(M_PI)
            self.sprite.name = "Starship2"
        }
        
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
        
        
        self.gun.position.x = 0
        self.gun.position.y = self.sprite.size.height + 20
        self.gun.name = "gun"
        self.sprite.addChild(gun)

      
    }
    
    func getSpeed() -> CGPoint {
        return self.speed
    }
    
    func setSpeed(newSpeed: CGPoint) {
        var spd = CGPoint(x: newSpeed.x, y: newSpeed.y)
        
        if newSpeed.x > 25 {
            spd = CGPoint (x: 25, y: newSpeed.y)
        }
        else if newSpeed.x < -25 {
            spd = CGPoint (x: -25, y: newSpeed.y)
        }
        else {
            spd = CGPoint (x: spd.x, y: newSpeed.y)
        }
        
        
        if newSpeed.y > 25 {
            spd = CGPoint (x: spd.x, y: 25)
        }
        else if newSpeed.x < -25 {
            spd = CGPoint (x: spd.x, y: -25)
        }
        else {
            spd = CGPoint (x: spd.x, y: newSpeed.y)
        }
        
        self.speed = spd
        
        let deltaX = Game.🚀2.sprite.position.x - Game.🚀1.sprite.position.x
        let deltaY = Game.🚀2.sprite.position.y - Game.🚀1.sprite.position.y
        /*if deltaX >= 0 && deltaY >= 0 {
            
        }
        else if deltaX >= 0 && deltaY <= 0 {
            
        }
        else if deltaX <= 0 && deltaY >= 0 {
            
        }
        else if deltaX <= 0 && deltaY >= 0 {
            
        }
        else {
            
        }*/
        
        // if playernumber is 2 multiply by -1
        //angle = atan2f(Float(deltaY), Float(deltaX))
        //println(angle)
        angle = atan2f(Float(deltaY), Float(deltaX))
        angle -= Float(M_PI/2)
        //println(angle)
        self.sprite.zRotation = CGFloat(angle)
        //let action = SKAction.rotateByAngle(CGFloat(angle), duration:0.1)
        //sprite.runAction(SKAction.repeatAction(action, count: 1))
        //sprite.runAction(SKAction.repeatActionForever(action))
    }
    
    func move (){
        self.sprite.physicsBody?.velocity = CGVector(dx: self.speed.x, dy: self.speed.y)
        

    }
    
    func fire (missileSpeed: CGPoint) -> Void {
        for var i = self.missileNumber; i < self.TOTAL_MISSILES; i++ {
            if !missiles[i].isBeingFired {
                var gunPosition =  sprite.childNodeWithName("gun")!.convertPoint(CGPointZero, toNode: sprite.parent!)
                missiles[i].setSpeed(missileSpeed, newPosition: gunPosition)
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
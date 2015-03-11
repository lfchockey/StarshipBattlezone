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
    var tankSize = CGSize()
    var isBeingFired = false
    
    init () {
        sprite = SKSpriteNode(imageNamed:"Missile")
        self.sprite.xScale = 0.1
        self.sprite.yScale = 0.1
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Missile"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = true
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
        
        var tempPositionX = newPosition.x
        var tempPositionY = newPosition.y
        
        if (speed.x >= 0 && speed.y > 0) {
            tempPositionX = newPosition.x + self.tankSize.width / 2
            tempPositionY = newPosition.y + self.tankSize.height / 2
            self.sprite.zRotation = CGFloat(-M_PI/4)
        }
        else if (speed.x <= 0 && speed.y > 0) {
            tempPositionX = newPosition.x - self.tankSize.width / 2
            tempPositionY = newPosition.y + self.tankSize.height / 2
            self.sprite.zRotation = CGFloat(M_PI/4)
        }
        else if (speed.x >= 0 && speed.y < 0) {
            tempPositionX = newPosition.x + self.tankSize.width / 2
            tempPositionY = newPosition.y - self.tankSize.height / 2
            self.sprite.zRotation = CGFloat(-3*M_PI/4)
        }
        else if (speed.x <= 0 && speed.y < 0) {
            tempPositionX = newPosition.x - self.tankSize.height / 2
            tempPositionY = newPosition.y - self.tankSize.width / 2
            self.sprite.zRotation = CGFloat(3*M_PI/4)
        }
        else {
            tempPositionX = newPosition.x + self.tankSize.width / 2
            tempPositionY = newPosition.y + self.tankSize.height / 2
            self.sprite.zRotation = CGFloat(M_PI/4)
        }
        
        self.sprite.position = CGPoint(x: tempPositionX, y: tempPositionY)
        
        self.sprite.physicsBody?.velocity = CGVector(dx: self.speed.x, dy: self.speed.y)
//        let xComponent: CGFloat = newSpeed.x
//        let yComponent: CGFloat = newSpeed.y
//        let impulseVector = CGVector(dx: xComponent, dy: yComponent)
//        self.sprite.physicsBody!.applyImpulse(impulseVector)
    }
    
    func move() {
        if (self.isBeingFired) {
            //  Check to see if bullet goes off the View
            if (self.sprite.position.x < 0 || self.sprite.position.x > self.viewSize.x || self.sprite.position.y < 0 || self.sprite.position.y > self.viewSize.y) {
                self.isBeingFired = false
                self.sprite.position = CGPoint(x: -50, y: -50)
            }
        }
    }
    
}
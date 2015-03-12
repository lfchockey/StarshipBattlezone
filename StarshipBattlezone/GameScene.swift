//
//  GameScene.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    override func didMoveToView(view: SKView) {
        self.userInteractionEnabled = true
        myLabel.text = "Ready...Set...Battle!!!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
       
        var parentViewSize = CGPoint(x: self.frame.width, y: self.frame.height)
        Game.🚀1.viewSize = parentViewSize
        Game.🚀2.viewSize = parentViewSize
        Game.🚀1.setSprite(Game.🚀1.imageName) // Added these two lines which makes the image no longer appear
        Game.🚀2.setSprite(Game.🚀2.imageName)
        
        self.addChild(Game.🚀1.sprite)
        self.addChild(Game.🚀2.sprite)
    

        // Add all of the Missiles as nodes to the
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            
            Game.🚀1.missiles[i].viewSize = parentViewSize
            Game.🚀2.missiles[i].viewSize = parentViewSize
            
            Game.🚀1.missiles[i].starshipSize = Game.🚀1.sprite.size
            Game.🚀2.missiles[i].starshipSize = Game.🚀2.sprite.size
            
            Game.🚀1.missiles[i].setSprite(i)
            Game.🚀2.missiles[i].setSprite(i)
            
            self.addChild(Game.🚀1.missiles[i].sprite) // This is the line that causes the touch to be disabled
            self.addChild(Game.🚀2.missiles[i].sprite)

        }
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zeroVector
        //println("self.physicsWorld.contactDelegate = \(self.physicsWorld.contactDelegate)")
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //println(touches)
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let deltaX = location.x - Game.🚀1.sprite.position.x
            let deltaY = location.y - Game.🚀1.sprite.position.y
            Game.🚀1.setSpeed(CGPoint(x: 25, y: 25))
            Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY))
        }
        myLabel.text = ""
        
        println("Starship1 - \(Game.🚀1.sprite.physicsBody?.categoryBitMask) Starship2 - \(Game.🚀2.sprite.physicsBody?.categoryBitMask)")
        println("Missile1 - \(Game.🚀1.missiles[0].sprite.physicsBody?.categoryBitMask) Missile2 - \(Game.🚀2.missiles[0].sprite.physicsBody?.categoryBitMask)")
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //println(Game.🚀2.sprite.physicsBody?.categoryBitMask)
        //myLabel.text = ""
        
        Game.🚀1.move()
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            Game.🚀1.missiles[i].move()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as SKSpriteNode
        let secondNode = contact.bodyB.node as SKSpriteNode
        
        println("\(firstNode.name) - \(secondNode.name)")
        
        
        // Starship1 collides with Missiles from Starship2
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship1.rawValue ) &&
        (contact.bodyB.categoryBitMask == ColliderType.Missile2.rawValue)) || ((contact.bodyA.categoryBitMask == ColliderType.Missile2.rawValue ) &&
        (contact.bodyB.categoryBitMask == ColliderType.Starship1.rawValue)){
            /*
                let contactPoint = contact.contactPoint
                let contact_y = contactPoint.y
                let target_y = secondNode.position.y
                let margin = secondNode.frame.size.height/2 - 25
                
                if (contact_y > (target_y - margin)) &&
                    (contact_y < (target_y + margin)) {
                        println("Hit")
                }
            */
            println("Missile 2 hit Starship1")
        }
        
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship2.rawValue ) &&
            (contact.bodyB.categoryBitMask == ColliderType.Missile1.rawValue)) || ((contact.bodyA.categoryBitMask == ColliderType.Missile1.rawValue ) &&
                (contact.bodyB.categoryBitMask == ColliderType.Starship2.rawValue)){
            println("Missile 1 hit Starship2")        
        }
        
    }
}

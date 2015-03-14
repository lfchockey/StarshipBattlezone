//
//  GameScene.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import SpriteKit

protocol gameSceneDelegate {
    func starship2Move()
}

protocol missileSound {

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var explosionAnimation = [SKTexture]()
    var delegate2:gameSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        
        
        
        //self.starship2Move() = MrBlack.starship2Move() //MrBlack.player1StarshipMove()
        
        self.view?.backgroundColor = UIColor(patternImage: UIImage(named: "SpaceBackground.png")!)
        //var bgImage = SKSpriteNode(imageNamed: "SpaceBackground")
        var bgLayer = SKNode();
        self.addChild(bgLayer)
        
        var bgTexture = SKTexture(imageNamed: "SpaceBackground")
        var doubleBg = CGFloat(-bgTexture.size().width*2)
        var bgDuration = NSTimeInterval(0.1 * bgTexture.size().width)
        var bgMove = SKAction.moveByX(doubleBg, y: 0, duration: bgDuration)
        var bgReset = SKAction.moveByX(-doubleBg, y: 0, duration: 0)
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([bgMove, bgReset]))
        
        for (var i=0; i < Int(2 + self.frame.size.width / (bgTexture.size().width * 2)); ++i) {
            var sp = SKSpriteNode(texture: bgTexture)
            sp.setScale(1.0)
            sp.zPosition = -20
            sp.anchorPoint = CGPointZero
            sp.position = CGPointMake(CGFloat(i) * CGFloat(sp.size.width), 0)
            sp.runAction(moveBgForever)
            bgLayer.addChild(sp)
        }
        //self.addChild(bgImage)
        //bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        
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
            
            self.addChild(Game.🚀1.missiles[i].sprite)
            self.addChild(Game.🚀2.missiles[i].sprite)

        }
        
        // Set up the explosion animation to use later when missiles collide with a starship
        let explosionAtlas = SKTextureAtlas(named: "explosions")
        for index in 0..<explosionAtlas.textureNames.count {
            let texture = "explosion\(index)"
            explosionAnimation += [explosionAtlas.textureNamed(texture)]
        }
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zeroVector
        //println("self.physicsWorld.contactDelegate = \(self.physicsWorld.contactDelegate)")
        initImages()
    }
    
    func initImages() {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //println(touches)
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let deltaX = location.x - Game.🚀1.sprite.position.x
            let deltaY = location.y - Game.🚀1.sprite.position.y
            Game.🚀1.setSpeed(CGPoint(x: 25, y: 25))
            MrBlack.starship2Move()
            Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY)) //var missileSprite = Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY))
            playFireMissileSound()
            //self.addChild(missileSprite)
        }
        myLabel.text = ""
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //println(Game.🚀2.sprite.physicsBody?.categoryBitMask)
        //myLabel.text = ""
        delegate2?.starship2Move()
        
        Game.🚀1.move()
        Game.🚀2.move()
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            Game.🚀1.missiles[i].move()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as SKSpriteNode
        let secondNode = contact.bodyB.node as SKSpriteNode
        
        //println("\(firstNode.name) - \(secondNode.name)")
        
        
        // Starship1 collides with Missiles from Starship2
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship1.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Missile2.rawValue)) {
        
            //println("\(firstNode.name) hit \(secondNode.name)")
            hitDetected(firstNode.name!, missileName: secondNode.name!)

        }
        else if ((contact.bodyA.categoryBitMask == ColliderType.Missile2.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Starship1.rawValue)) {
            
            hitDetected(secondNode.name!, missileName: firstNode.name!)
            
        }
        
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship2.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Missile1.rawValue)) {
            
            //println("\(firstNode.name) hit \(secondNode.name)")
            hitDetected(firstNode.name!, missileName: secondNode.name!)
            //println(Game.🚀1.missiles)
            //contact.bodyB.node?.removeFromParent()
            
        }
        else if ((contact.bodyA.categoryBitMask == ColliderType.Missile1.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Starship2.rawValue)) {
            
            hitDetected(secondNode.name!, missileName: firstNode.name!)
            
        }
        
        /*
        // Ship bullet hit an invader
        [self runAction:[SKAction playSoundFileNamed:@"InvaderHit.wav" waitForCompletion:NO]];
        [contact.bodyA.node removeFromParent];
        [contact.bodyB.node removeFromParent];
*/
        
    }
    
    func hitDetected(starshipName: String, missileName: String){
        if starshipName == Game.🚀1.sprite.name {
            // Starship2 scores
            Game.🚀1.life -= 1
            
            // Check to see if Game is over
            gameOverCheck()
            
            // Remove proper missile from the screen
            for i in 0..<10 {
                if missileName == Game.🚀2.missiles[i].sprite.name {
                    // Set the velocity to zero
                    Game.🚀2.missiles[i].sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    // Move missile
                    Game.🚀2.missiles[i].sprite.position = CGPoint(x: -50, y: -50)
                    
                    // Make exlposion
                    
                    // Play sound
                    println(Game.🚀2.missiles[i].sprite.name)
                }
            }
        }
        else if starshipName == Game.🚀2.sprite.name {
            // Starship2 scores
            Game.🚀2.life -= 1
            
            // Check to see if Game is over
            gameOverCheck()
            
            // Remove proper missile from the screen
            for i in 0..<10 {
                if missileName == Game.🚀1.missiles[i].sprite.name {
                    // Set the velocity to zero
                    Game.🚀1.missiles[i].sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    let contactPoint = Game.🚀1.missiles[i].sprite.position
                    
                    // Move missile
                    var moveMissile = SKAction.moveTo(CGPoint(x: -50, y: -50), duration: 0.01)
                    var moveAction = SKAction.repeatAction(moveMissile, count: 1)
                    Game.🚀1.missiles[i].sprite.runAction(moveAction)
                    Game.🚀1.missiles[i].isBeingFired = false
                    
                    // Play sound
                    playExplosionSound()
                    // Make exlposion
                    explodeMissile(contactPoint)
                    

                }
            }
        }

    }
    
    func explodeMissile(whereToExplode: CGPoint) {
        let explosionSprite = SKSpriteNode(imageNamed:"explosion0")
        self.addChild(explosionSprite)
        explosionSprite.position = whereToExplode
        let animate = SKAction.animateWithTextures(explosionAnimation, timePerFrame: 0.05)
        let explosionSequence = SKAction.sequence([animate, SKAction.removeFromParent()])
        explosionSprite.runAction(SKAction.repeatAction(explosionSequence, count: 1))
    }
    
    func playExplosionSound() {
        self.runAction(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true))
    }
    
    func playFireMissileSound() {
        self.runAction(SKAction.playSoundFileNamed("missile.mp3", waitForCompletion: true))
    }
    
    func gameOverCheck(){
        
        if Game.🚀1.life <= 0 {
            // Starship2 wins
            
            // Stop the update function
        }
        else if Game.🚀2.life <= 0 {
            // Starship1 wins
            
        }
    }
}

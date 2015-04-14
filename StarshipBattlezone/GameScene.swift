//
//  GameScene.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import SpriteKit

protocol gameSceneDelegate {
    func starship1Move()
    func starship2Move()
}

protocol missileSound {

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: GameViewController? // This pointer is needed to create segue back to PPVC after gameOver
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    let starship1Score = SKLabelNode(fontNamed: "Chalkduster")
    let starship2Score = SKLabelNode(fontNamed: "Chalkduster")
    var explosionAnimation = [SKTexture]()
    
    var player1Delegate:gameSceneDelegate?
    var player2Delegate:gameSceneDelegate?
    
    var updatesCalled = 0
    var gameOver = false
    var gameStarted = false
    
    override func didMoveToView(view: SKView) {
        self.scene?.paused = true
        // Display the name of the players
        
        let p1Node = childNodeWithName("lblPlayer1Name") as! SKLabelNode
        let p2Node = childNodeWithName("lblPlayer2Name") as! SKLabelNode
        
        p1Node.text = Game.🚀1.name
        p2Node.text = Game.🚀2.name
        
        setPlayerClasses()
        
        self.view?.backgroundColor = UIColor(patternImage: UIImage(named: "SpaceBackground.png")!)
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

        
        self.userInteractionEnabled = true
        
        myLabel.text = "Ready...Set...Battle!!!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        starship1Score.text = String(Game.🚀1.life)
        starship1Score.fontSize = 24
        starship1Score.position = CGPoint(x: CGRectGetMaxX(self.frame) - 40, y:CGRectGetMaxY(self.frame) - 40);
        self.addChild(starship1Score)
        
        starship2Score.text = String(Game.🚀2.life)
        starship2Score.fontSize = 24
        starship2Score.position = CGPoint(x: CGRectGetMaxX(self.frame) - 40, y:CGRectGetMaxY(self.frame) - 80);
        self.addChild(starship2Score)
        

       
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //println(touches)
        gameStarted = true
        myLabel.text = ""
        self.scene?.paused = false
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let deltaX = location.x - Game.🚀1.sprite.position.x
            let deltaY = location.y - Game.🚀1.sprite.position.y
            Game.🚀1.setSpeed(CGPoint(x: 25, y: 25))
            //MrBlack.starship2Move()
            Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY)) //var missileSprite = Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY))
            playFireMissileSound()
            //self.addChild(missileSprite)
        }
        
        if gameOver {
            // Jump back to main selection screen
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if !gameOver && gameStarted {
            myLabel.text = String(Game.🚀2.life)
            player1Delegate?.starship1Move()
            player2Delegate?.starship2Move()

            for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
                Game.🚀1.missiles[i].move()
            }
            for i in 0 ..< Game.🚀2.TOTAL_MISSILES {
                Game.🚀2.missiles[i].move()
            }
            
            updatesCalled++
            updateScores()
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // This is needed in order to prevent a single contact to be registered multiple times.
        // println("didBeginContact: (\(contact.contactPoint.x), \(contact.contactPoint.y)), \(updatesCalled)")
        if(updatesCalled == 0) {return} // No real change since last call
        updatesCalled = 0
        
        let firstNode = contact.bodyA.node as! SKSpriteNode
        let secondNode = contact.bodyB.node as! SKSpriteNode
        //println(secondNode.position.x)
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
            //if (secondNode.position.x >= 0) || (secondNode.position.y >= 0){
                
                //println("\(firstNode.name) hit \(secondNode.name)")
                hitDetected(firstNode.name!, missileName: secondNode.name!)
                //println(Game.🚀1.missiles)
                //contact.bodyB.node?.removeFromParent()
            //}
        }
        else if ((contact.bodyA.categoryBitMask == ColliderType.Missile1.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Starship2.rawValue)) {
            
            hitDetected(secondNode.name!, missileName: firstNode.name!)
            
        }
        

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
                    //println(Game.🚀2.missiles[i].sprite.name)
                }
            }
        }
        else if starshipName == Game.🚀2.sprite.name {
            
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
            // Starship1 scores
            Game.🚀2.life -= 1
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
        self.runAction(SKAction.playSoundFileNamed("missile.mp3", waitForCompletion: false))
    }
    
    func gameOverCheck(){
        var tie = false
        var gameOverMessage = ""
        // Starship2 wins
        if Game.🚀1.life <= 0 {
            gameOver = true
            gameOverMessage = "\(Game.🚀2.life) - \(Game.🚀2.name) (Winner) \(Game.🚀1.name) - \(Game.🚀1.life) (Loser)"
            if Game.🚀2.life <= 0 {
                tie = true
                gameOverMessage = "Tie game"
            }
        }
        else if Game.🚀2.life <= 0 { // Starship2 wins
            gameOver = true
            gameOverMessage = "\(Game.🚀1.life) - \(Game.🚀1.name) (Winner) \(Game.🚀2.name) - \(Game.🚀2.life) (Loser)"
            if Game.🚀1.life <= 0 {
                tie = true
                gameOverMessage = "Tie game"
            }
        }
        //gameOverMessage = "\(Game.🚀1.life)"
        
        if gameOver {
            gameStarted = false
            let GVC = GameViewController()

            self.scene?.paused = true
            Game.🚀1.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Game.🚀2.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let alertController = UIAlertController(title: "iOScreator", message: gameOverMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Main Menu", style: UIAlertActionStyle.Default,handler: nil))
            //self.view?.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            self.viewController?.presentViewController(alertController, animated: true, completion: nil)
            self.viewController?.moveToMenu()
            //self.viewController?.performSegueWithIdentifier("Menu", sender: nil)
            // Show message on who won
            //myLabel.text = "Hello" //gameOverMessage
            // Segue back to playerPicker ViewController

        }
        
    }
    
    func setPlayerClasses() {
        //println(Game.🚀1.name)
        if Game.🚀1.name == "Starship-Mr Black" {
            player1Delegate = MrBlack()
        }
        else if Game.🚀1.name == "Starship-Griffin Atkinson" {
            player1Delegate = GriffinAtkinson()
        }
        else if Game.🚀1.name == "Starship-James Bleau" {
            //player1Delegate = JamesBleau()
        }
        else if Game.🚀1.name == "Starship-Griffon Charron" {
            //player1Delegate = GriffonCharron()
        }
        else if Game.🚀1.name == "Starship-Brayden Doyle" {
            //player1Delegate = BraydenDoyle()
        }
        else if Game.🚀1.name == "Starship-Matt Falkner" {
            //player1Delegate = MattFalkner()
        }
        else if Game.🚀1.name == "Starship-Jared Hayes" {
            //player1Delegate = JaredHayes()
        }
        else if Game.🚀1.name == "Starship-Brayden Konink" {
            //player1Delegate = BraydenKonink()
        }
        else if Game.🚀1.name == "Starship-Daniel MacCormick" {
            //player1Delegate = DanielMacCormick()
        }
        else if Game.🚀1.name == "Starship-Quinton MacDougall" {
            //player1Delegate = QuintonMacDougall()
        }
        else if Game.🚀1.name == "Starship-CJ Wright" {
            //player1Delegate = CJWright()
        }
        
        if Game.🚀2.name == "Starship-Mr Black" {
            player2Delegate = MrBlack()
        }
        else if Game.🚀2.name == "Starship-Griffin Atkinson" {
            player2Delegate = GriffinAtkinson()
        }
        else if Game.🚀2.name == "Starship-James Bleau" {
            //player2Delegate = JamesBleau()
        }
        else if Game.🚀2.name == "Starship-Griffon Charron" {
            //player2Delegate = GriffonCharron()
        }
        else if Game.🚀2.name == "Starship-Brayden Doyle" {
            //player2Delegate = BraydenDoyle()
        }
        else if Game.🚀2.name == "Starship-Matt Falkner" {
            //player2Delegate = MattFalkner()
        }
        else if Game.🚀2.name == "Starship-Jared Hayes" {
            //player2Delegate = JaredHayes()
        }
        else if Game.🚀2.name == "Starship-Brayden Konink" {
            //player2Delegate = BraydenKonink()
        }
        else if Game.🚀2.name == "Starship-Daniel MacCormick" {
            //player2Delegate = DanielMacCormick()
        }
        else if Game.🚀2.name == "Starship-Quinton MacDougall" {
            //player2Delegate = QuintonMacDougall()
        }
        else if Game.🚀2.name == "Starship-CJ Wright" {
            //player2Delegate = CJWright()
        }

    }
    
    func updateScores() {
        starship1Score.text = String(Game.🚀1.life)
        starship2Score.text = String(Game.🚀2.life)
    }
}

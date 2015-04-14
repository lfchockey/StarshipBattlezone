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

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: GameViewController? // This pointer is needed to create segue back to PPVC after gameOver
    
    // Set up labels to display scores
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    let starship1Score = SKLabelNode(fontNamed: "Chalkduster")
    let starship2Score = SKLabelNode(fontNamed: "Chalkduster")
    
    // An array of SKTextures for animating the explosions
    var explosionAnimation = [SKTexture]()
    
    // These delegates are needed in order to be able to call each student's 
    //      StarshipMove() functions within different classes
    var player1Delegate:gameSceneDelegate?
    var player2Delegate:gameSceneDelegate?
    
    var updatesCalled = 0 // variable needed to prevent multiple collisions from happening
    var gameOver = false
    var gameStarted = false
    
    override func didMoveToView(view: SKView) {
        self.scene?.paused = true   // Pause the game when we first get to the GameScene
        
        // Creating a connection with the labels that are displayed in the GameScene.sks file
        //      These are used to display each player's name
        let p1Node = childNodeWithName("lblPlayer1Name") as! SKLabelNode
        let p2Node = childNodeWithName("lblPlayer2Name") as! SKLabelNode
        p1Node.text = Game.🚀1.name + ":"
        p2Node.text = Game.🚀2.name + ":"
        
        // This function sets the correct StarshipMove() functions depending on which
        //      students are playing the game.
        setPlayerClasses()
        
        // Create the background of the GameScene.
        self.view?.backgroundColor = UIColor(patternImage: UIImage(named: "SpaceBackground.png")!)
        var bgLayer = SKNode();
        self.addChild(bgLayer)
        
        // The following code allows the background to move behind the Starships
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

        // A property of a ViewController that allows user interaction
        //      This is needed to start the game.
        self.userInteractionEnabled = true
        
        // Display a label before the game begins
        myLabel.text = "Ready...Set...Battle!!!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        // Update the Starship1's score
        starship1Score.text = String(Game.🚀1.life)
        starship1Score.fontSize = 24
        //starship1Score.position = CGPoint(x: p1Node.frame.width/2 + p1Node.position.x + 5, y:CGRectGetMaxY(self.frame) - 40);
        starship1Score.position = CGPoint(x: CGRectGetMaxX(self.frame) - 35, y:CGRectGetMaxY(self.frame) - 40);
        self.addChild(starship1Score)
        
        // Update the Starship2's score
        starship2Score.text = String(Game.🚀2.life)
        starship2Score.fontSize = 24
        starship2Score.position = CGPoint(x: CGRectGetMaxX(self.frame) - 35, y:CGRectGetMaxY(self.frame) - 80);
        self.addChild(starship2Score)
        

        // Set the viewSize of the Starships so they understand when they go out of bounds and
        //      need to wrap to the other side of the screen
        var parentViewSize = CGPoint(x: self.frame.width, y: self.frame.height)
        Game.🚀1.viewSize = parentViewSize
        Game.🚀2.viewSize = parentViewSize
        
        // Use the setSprite function of a Starship class which sets all of the initial properties of the Starships
        Game.🚀1.setSprite(Game.🚀1.imageName)
        Game.🚀2.setSprite(Game.🚀2.imageName)
        
        // Add the Starships to the Scene
        self.addChild(Game.🚀1.sprite)
        self.addChild(Game.🚀2.sprite)
    

        // Add all of the Missiles as nodes to the Scene
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
        
        // Set some of the properties of the physicsWorld
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zeroVector
    }
    
    // When the user touches the screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        gameStarted = true  // the game has started
        myLabel.text = ""   // clear the label's text
        self.scene?.paused = false  // start the game.
        
        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            let deltaX = location.x - Game.🚀1.sprite.position.x
//            let deltaY = location.y - Game.🚀1.sprite.position.y
//            Game.🚀1.setSpeed(CGPoint(x: 25, y: 25))
//            MrBlack.starship2Move()
//            Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY)) //var missileSprite = Game.🚀1.fire(CGPoint(x: deltaX, y: deltaY))
//            playFireMissileSound()
//            self.addChild(missileSprite)
        }
        
        if gameOver {
            // Jump back to main selection screen
        }
    }
   
    // This function is called just prior to a frame being displayed
    override func update(currentTime: CFTimeInterval) {
        
        // If the game is currently in progress
        if !gameOver && gameStarted {
            
            // Call the StarshipMove() functions
            player1Delegate?.starship1Move()
            player2Delegate?.starship2Move()

            // Move all of the missiles that are currently on the screen
            for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
                Game.🚀1.missiles[i].move()
            }
            for i in 0 ..< Game.🚀2.TOTAL_MISSILES {
                Game.🚀2.missiles[i].move()
            }
            
            updatesCalled++     // this variable is needed to prevent multiple collisions of the same missile
            updateScores()
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // This is needed in order to prevent a single contact to be registered multiple times.
        if(updatesCalled == 0) {return} // No real change since last call
        updatesCalled = 0
        
        // Set the Nodes which contacted each other
        let firstNode = contact.bodyA.node as! SKSpriteNode
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        // Starship1 collides with Missiles from Starship2
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship1.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Missile2.rawValue)) {
            hitDetected(firstNode.name!, missileName: secondNode.name!)
        }
        else if ((contact.bodyA.categoryBitMask == ColliderType.Missile2.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Starship1.rawValue)) {
            hitDetected(secondNode.name!, missileName: firstNode.name!)
        }
        
        // Starship2 collides with Missiles from Starship1
        if ((contact.bodyA.categoryBitMask == ColliderType.Starship2.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Missile1.rawValue)) {
            hitDetected(firstNode.name!, missileName: secondNode.name!)
        }
        else if ((contact.bodyA.categoryBitMask == ColliderType.Missile1.rawValue ) && (contact.bodyB.categoryBitMask == ColliderType.Starship2.rawValue)) {
            hitDetected(secondNode.name!, missileName: firstNode.name!)
        }
        

    }
    
    func hitDetected(starshipName: String, missileName: String){
        
        // Starship1 was hit by a missile
        if starshipName == Game.🚀1.sprite.name {
            
            Game.🚀1.life -= 1  // Starship2 scores
            
            // Check to see if Game is over
            gameOverCheck()
            
            // Remove proper missile from the screen
            for i in 0..<10 {
                if missileName == Game.🚀2.missiles[i].sprite.name {
                    // Set the velocity to zero
                    Game.🚀2.missiles[i].sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    // Identify where the Starship was hit
                    let contactPoint = Game.🚀2.missiles[i].sprite.position
                    
                    // Move missile off the screen
                    var moveMissile = SKAction.moveTo(CGPoint(x: -50, y: -50), duration: 0.01)
                    var moveAction = SKAction.repeatAction(moveMissile, count: 1)
                    Game.🚀2.missiles[i].sprite.runAction(moveAction)
                    Game.🚀2.missiles[i].isBeingFired = false
                    
                    // Play sound
                    playExplosionSound()
                    // Make exlposion
                    explodeMissile(contactPoint)
                }
            }
        }
        else if starshipName == Game.🚀2.sprite.name {
            // Starship1 scores
            Game.🚀2.life -= 1
            
            // Check to see if Game is over
            gameOverCheck()
            
            // Remove proper missile from the screen
            for i in 0..<10 {
                if missileName == Game.🚀1.missiles[i].sprite.name {
                    // Set the velocity to zero
                    Game.🚀1.missiles[i].sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    // Identify where the Starship was hit
                    let contactPoint = Game.🚀1.missiles[i].sprite.position
                    
                    // Move missile off the screen
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
    
    // Function for progressing through the animation of a missile exploding
    func explodeMissile(whereToExplode: CGPoint) {
        let explosionSprite = SKSpriteNode(imageNamed:"explosion0")
        self.addChild(explosionSprite)
        explosionSprite.position = whereToExplode
        let animate = SKAction.animateWithTextures(explosionAnimation, timePerFrame: 0.05)
        let explosionSequence = SKAction.sequence([animate, SKAction.removeFromParent()])
        explosionSprite.runAction(SKAction.repeatAction(explosionSequence, count: 1))
    }
    
    // Play the explosion sound when a missile hits a Starship
    func playExplosionSound() {
        self.runAction(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: true))
    }
    
    // Play sound when a missile is fired
    func playFireMissileSound() {
        self.runAction(SKAction.playSoundFileNamed("missile.mp3", waitForCompletion: false))
    }
    
    // Function that is constantly called to see if the game is over
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
        
        if gameOver {
            gameStarted = false
            let GVC = GameViewController()

            self.scene?.paused = true
            Game.🚀1.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Game.🚀2.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let alertController = UIAlertController(title: "Game Over", message: gameOverMessage, preferredStyle: UIAlertControllerStyle.Alert)
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

    
    // This function uses the player Delegates to determine which StarshipMove functions need to be called
    //      based on which students are playing each other.
    func setPlayerClasses() {

        if Game.🚀1.imageName == "Starship-Mr Black" {
            player1Delegate = MrBlack()
        }
        else if Game.🚀1.imageName == "Starship-Griffin Atkinson" {
            player1Delegate = GriffinAtkinson()
        }
        else if Game.🚀1.imageName == "Starship-James Bleau" {
            //player1Delegate = JamesBleau()
        }
        else if Game.🚀1.imageName == "Starship-Griffon Charron" {
            //player1Delegate = GriffonCharron()
        }
        else if Game.🚀1.imageName == "Starship-Brayden Doyle" {
            //player1Delegate = BraydenDoyle()
        }
        else if Game.🚀1.imageName == "Starship-Matt Falkner" {
            //player1Delegate = MattFalkner()
        }
        else if Game.🚀1.imageName == "Starship-Jared Hayes" {
            //player1Delegate = JaredHayes()
        }
        else if Game.🚀1.imageName == "Starship-Brayden Konink" {
            //player1Delegate = BraydenKonink()
        }
        else if Game.🚀1.imageName == "Starship-Daniel MacCormick" {
            //player1Delegate = DanielMacCormick()
        }
        else if Game.🚀1.imageName == "Starship-Quinton MacDougall" {
            //player1Delegate = QuintonMacDougall()
        }
        else if Game.🚀1.imageName == "Starship-CJ Wright" {
            //player1Delegate = CJWright()
        }
        
        if Game.🚀2.imageName == "Starship-Mr Black" {
            player2Delegate = MrBlack()
        }
        else if Game.🚀2.imageName == "Starship-Griffin Atkinson" {
            player2Delegate = GriffinAtkinson()
        }
        else if Game.🚀2.imageName == "Starship-James Bleau" {
            //player2Delegate = JamesBleau()
        }
        else if Game.🚀2.imageName == "Starship-Griffon Charron" {
            //player2Delegate = GriffonCharron()
        }
        else if Game.🚀2.imageName == "Starship-Brayden Doyle" {
            //player2Delegate = BraydenDoyle()
        }
        else if Game.🚀2.imageName == "Starship-Matt Falkner" {
            //player2Delegate = MattFalkner()
        }
        else if Game.🚀2.imageName == "Starship-Jared Hayes" {
            //player2Delegate = JaredHayes()
        }
        else if Game.🚀2.imageName == "Starship-Brayden Konink" {
            //player2Delegate = BraydenKonink()
        }
        else if Game.🚀2.imageName == "Starship-Daniel MacCormick" {
            //player2Delegate = DanielMacCormick()
        }
        else if Game.🚀2.imageName == "Starship-Quinton MacDougall" {
            //player2Delegate = QuintonMacDougall()
        }
        else if Game.🚀2.imageName == "Starship-CJ Wright" {
            //player2Delegate = CJWright()
        }

    }
    
    // Display the scores in the label
    func updateScores() {
        starship1Score.text = String(Game.🚀1.life)
        starship2Score.text = String(Game.🚀2.life)
    }
}

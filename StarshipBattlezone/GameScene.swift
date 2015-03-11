//
//  GameScene.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
        //println(Game.🚀1.sprite)
        //println("------")
        
        // Add all of the Missiles as nodes to the
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            
            Game.🚀1.missiles[i].viewSize = parentViewSize
            Game.🚀2.missiles[i].viewSize = parentViewSize
            
            Game.🚀1.missiles[i].tankSize = Game.🚀1.sprite.size
            Game.🚀2.missiles[i].tankSize = Game.🚀2.sprite.size
            
            Game.🚀1.missiles[i].setSprite()
            Game.🚀2.missiles[i].setSprite()
            
            
            self.addChild(Game.🚀1.missiles[i].sprite) // This is the line that causes the touch to be disabled
            self.addChild(Game.🚀2.missiles[i].sprite)

        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //println(touches)
        myLabel.text = ""
        
        Game.🚀1.setSpeed(CGPoint(x: 10, y: 10))
        
        Game.🚀1.fire(CGPoint(x: -80, y: -80))
        
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            Game.🚀1.missiles[i].move()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //println(currentTime)
        myLabel.text = ""
    }
}

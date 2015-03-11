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
        
        myLabel.text = "Ready...Set...Battle!!!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        Game.🚀1.viewSize = CGPoint(x: self.frame.width, y: self.frame.height)
        Game.🚀2.viewSize = CGPoint(x: self.frame.width, y: self.frame.height)
        self.addChild(Game.🚀1.sprite)
        self.addChild(Game.🚀2.sprite)
        
        // Add all of the Missiles as nodes to the
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            Game.🚀1.missiles[i].viewSize = Game.🚀1.viewSize
            Game.🚀2.missiles[i].viewSize = Game.🚀2.viewSize
            Game.🚀1.missiles[i].tankSize = Game.🚀1.sprite.size
            Game.🚀2.missiles[i].tankSize = Game.🚀2.sprite.size
            self.addChild(Game.🚀1.missiles[i].sprite)
            self.addChild(Game.🚀2.missiles[i].sprite)
        }

        println(Game.🚀1.sprite)
        println(Game.🚀2.sprite)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println(touches)
        myLabel.text = ""
        
        Game.🚀1.setSpeed(CGPoint(x: 10, y: 10))
        
        Game.🚀1.fire(CGPoint(x: -80, y: -80))
        
        for i in 0 ..< Game.🚀1.TOTAL_MISSILES {
            Game.🚀1.missiles[i].move()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

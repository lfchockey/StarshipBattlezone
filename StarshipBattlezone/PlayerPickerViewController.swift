//
//  PlayerPickerViewController.swift
//  StarshipBattlezone
//
//  Created by Mason Black on 2015-03-10.
//  Copyright (c) 2015 Mason Black. All rights reserved.
//

import UIKit
import SpriteKit

// Create the global 'Game' variables we'll be using throughout the game.
struct Game {
    static var 🚀1 = Starship(playerNum: 1) 
    static var 🚀2 = Starship(playerNum: 2)
    
    static var students = ["Mr Black", "Griffin Atkinson", "James Bleau", "Griffon Charron", "Brayden Doyle", "Matt Falkner", "Jared Hayes", "Brayden Konink", "Daniel MacCormick", "Quinton MacDougall", "CJ Wright"]
    
    static let starship1Category : UInt32 = 0x00
    static let missile1Category : UInt32 = 0x01
    static let starship2Category : UInt32 = 0x02
    static let missile2Category : UInt32 = 0x04
    static let worldCategory : UInt32 = 0x08
}

enum ColliderType: UInt32 {
    case Starship1 = 1
    case Missile1 = 2
    case Starship2 = 4
    case Missile2 = 8
    case Space = 16
}

class PlayerPickerViewController: UIViewController, UIPickerViewDelegate {

    //constants for the collision bitmap
//    static const uint32_t starship1Category = 1 << 0;
//    static const uint32_t missile1Category = 1 << 1;
//    static const uint32_t starship2Category = 1 << 2;
//    static const uint32_t starship3Category = 1 << 4;
    
    // Connect the UIPickerView from the Storyboard - make the IBOutlet connection
    // Make sure to also connect the UIPickerView with the ViewController in the 
    //      Storyboard as both a Delegate and Datasource.
    @IBOutlet weak var Player1PickerView: UIPickerView!
    @IBOutlet weak var Player2PickerView: UIPickerView!
    
    // Declare students in an array to use as Player1 and Player2
    
    var imageNames: [String] = []
   
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Map all of the names from the 'students' array into an 'imageNames' array
        imageNames = Game.students.map {("Starship-\($0)")}
        // Start assigning properties of the Starships
        Game.🚀1.name = imageNames[0]
        Game.🚀1.imageName = imageNames[0]
        Game.🚀2.name = imageNames[0]
        Game.🚀2.imageName = imageNames[0]
        //Game.🚀1.setSprite(Game.🚀1.imageName)
        //Game.🚀2.setSprite(Game.🚀2.imageName)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Game.students.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Game.students[row]
    }
    
    // This function is called when a row is picked from the PickerView
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var studentSelected = Game.students[row]
        
        // Map the image names to the textures array. Each of these is an individual file stored in the playground package
        let textures: [SKTexture] = Game.students.map { SKTexture(imageNamed: "Starship-\($0)") }
        
        //println(textures)

        if Player1PickerView == pickerView
        {
            Game.🚀1.name = Game.students[row]
            Game.🚀1.imageName = imageNames[row]
            //Game.🚀1.setSprite(imageNames[row])
        }
        else
        {
            Game.🚀2.name = Game.students[row]
            Game.🚀2.imageName = imageNames[row]
            //Game.🚀2.setSprite(imageNames[row])
        }
        
                
    }
    

}

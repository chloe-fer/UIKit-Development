//
//  GameViewController.swift
//  Project-29
//
//  Created by Chloe Fermanis on 6/11/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var currentGame: GameScene?

    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    // Challenge 1: Add score
    @IBOutlet var player1Score: UILabel!
    @IBOutlet var player2Score: UILabel!
     
    
    @IBOutlet var gameOverLabel: UILabel!
    
    // Challenge 1: Add score
    var score1 = 0 {
        didSet {
            player1Score.text = "Score: \(score1)"
        }
    }
    
    var score2 = 0 {
        didSet {
            player2Score.text = "Score: \(score2)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        gameOverLabel.isHidden = true
        
        player1Score.text = "Score: 0"
        player2Score.text = "Score: 0"
        
        angleSlider.value = 45
        velocitySlider.value = 125
        
        angleChanged(self)
        velocityChanged(self)

                
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"

    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"

    }
    
    @IBAction func launch(_ sender: UIButton) {
        
        if sender.currentTitle == "LAUNCH" {
            
            angleSlider.isHidden = true
            angleLabel.isHidden = true

            velocitySlider.isHidden = true
            velocityLabel.isHidden = true

            launchButton.isHidden = true

            currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
        } else {
            
            gameOverLabel.isHidden = true
            currentGame?.newGameSetup()
            
        }
        
        
        
    }
    
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }

        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
           
        launchButton.isHidden = false
        
    }
    
    
}

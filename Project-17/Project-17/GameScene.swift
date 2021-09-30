//
//  GameScene.swift
//  Project-17
//
//  Created by Chloe Fermanis on 23/9/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    
    var gameTimer: Timer?
    var enemyCount = 0
    var timerInterval: Double = 1.0
    
    var isGameOver = false
    var isShipTouched = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        player.name = "ship"
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    @objc func createEnemy() {
        
        // guard !isGameOver else { return }
        // Day 63 - C3: stop creating space debris after the player has died.
        if !isGameOver  {
            
            enemyCount += 1

            // Day 63 - C2: subtract 0.1 from timer after 20 enemies have been created.
            if enemyCount % 20 == 0 {
                gameTimer?.invalidate()
                timerInterval -= 0.1
                gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
            
            guard let enemy = possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
                        
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5 // spinning
            sprite.physicsBody?.linearDamping = 0   // never slow down
            sprite.physicsBody?.angularDamping = 0  // never stop spinning
            

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           
        // Day 62 - C1: stop player from cheating by lifting their finger and tapping elsewhere
        if isShipTouched {
            
            guard let touch = touches.first else { return }
            var location = touch.location(in: self)

            
            if location.y < 100 {
                location.y = 100
            } else if location.y > 600 {
                location.y = 668
            }
            
            player.position = location
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        gameTimer?.invalidate()
        player.removeFromParent()
        isGameOver = true
        
        
    }
    
    // Day 62 - C1: stop player from cheating by lifting their finger and tapping elsewhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if player.contains(location) {
            isShipTouched = true
        }
    }
    
    // Day 62 - C1: stop player from cheating by lifting their finger and tapping elsewhere
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isShipTouched = false
    }
    
}

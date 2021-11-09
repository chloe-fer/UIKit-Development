//
//  GameScene.swift
//  Project-29
//
//  Created by Chloe Fermanis on 6/11/21.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var buildings = [BuildingNode]()
    
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var windLabel: SKLabelNode!
    
    var currentPlayer = 1
    var wind: CGFloat = 0.0
    var gameOver = false
    
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)

        createBuildings()
        createPlayers()
        createWind()
        
        physicsWorld.contactDelegate = self
        
    }
    
    // Challenge 3: Add wind
    func createWind() {
        
        windLabel = SKLabelNode(fontNamed: "Helvetica")
        windLabel.fontSize = 18
        windLabel.color = SKColor.white
        windLabel.position = CGPoint(x: frame.midX, y: 610)
        wind = CGFloat.random(in: -2...2)
        
        physicsWorld.gravity = CGVector(dx: wind, dy: -10)
        
        let windSpeed = Int(abs(wind) * 10)
    
        if wind < 0 {
            windLabel.text = "Wind: \(windSpeed) km/hr <<< "
        } else if wind > 0 {
            windLabel.text = "Wind: \(windSpeed) km/hr >>> "
        } else {
            windLabel.text = "No wind today!"
        }
        
        addChild(windLabel)
        
    }
    
    func createBuildings() {
        
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            
        } else {
            
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            
        }
        
        
        
    }
    
    func createPlayers() {
        
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count-2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.contactTestBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
        }
    }
    
    func destroy(player: SKSpriteNode) {
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        player.removeFromParent()
        banana.removeFromParent()
        
        // Challenge 1: Add score
        if currentPlayer == 1 {
            viewController?.score1 += 1
        } else {
            viewController?.score2 += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if self.viewController?.score2 == 3 || self.viewController?.score1 == 3 {
             
                // Game Over
                self.gameOver = true
                self.viewController?.gameOverLabel.isHidden = false
                self.viewController?.launchButton.setTitle("NEW GAME", for: .normal)
                self.viewController?.launchButton.isHidden = false

                
            } else {
                
                self.gameOver = false
                self.newGameSetup()
            }
        }
    }
    
    func newGameSetup() {
        
        let newGame = GameScene(size: self.size)
        newGame.viewController = self.viewController
        self.viewController?.currentGame = newGame
        self.viewController?.launchButton.setTitle("LAUNCH", for: .normal)
        
        if gameOver {
            viewController?.score1 = 0
            viewController?.score2 = 0
        }
        
        self.changePlayer()
        newGame.currentPlayer = self.currentPlayer
        
        let transition = SKTransition.doorway(withDuration: 1.5)
        self.view?.presentScene(newGame, transition: transition)
    }
    
    
    func changePlayer() {
        
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        
        guard let building = building as? BuildingNode else { return }
        
        // convert contactPoint into the building space
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }

}

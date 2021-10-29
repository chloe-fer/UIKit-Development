//
//  GameScene.swift
//  Project-26
//
//  Created by Chloe Fermanis on 27/10/21.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameOver = false
    var motionManager: CMMotionManager!
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var currentLevel = 1
    
    var scoreLabel: SKLabelNode!
    var isTeleporting = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
        
    override func didMove(to view: SKView) {
            
        loadLevel(level: currentLevel)
        createPlayer()
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.stopAccelerometerUpdates()
    }
    
    // Challenge 1: refactor load level function
    func loadLevel(level: Int) {
        
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else { fatalError("Could not find level1.txt in the app bundle.") }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not load level1.txt from the app bundle.") }
        
        loadBackground()
         
        isTeleporting = false
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                switch letter {
                case "x":
                    loadWall(at: position)
                case "v":
                    loadVortex(at: position)
                case "s":
                    loadStar(at: position)
                case "f":
                    loadFinish(at: position)
                case "t":
                    loadTeleport(at: position)
                case " ":
                    break
                default:
                    fatalError("Unknown level letter: \(letter)")
                }
                
            }
        }
    }
    
    func loadBackground() {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    func loadWall(at position: CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadVortex(at position: CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        // spinning
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadStar(at position: CGPoint) {
    
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        // when player touches star
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        // no bounce
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func loadFinish(at position: CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }

    // Challenge 3
    func loadTeleport(at position: CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "teleport1")
        node.name = "teleport"
        node.size = CGSize(width: 50, height: 50)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 3)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        //node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    
    func createPlayer() {
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        // a mask that defines which category this physics body belongs too.
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        
        // a mask that defines which categories of bodies cause intersection notifications
        // with this physics body.
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        
        // a mask that defines which categories of physics bodies can collide with this pb.
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        
        if node.name == "vortex" {
            
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [ weak self ] in
                self?.createPlayer()
                self?.isGameOver = false
            }
            
        } else if node.name == "star" {
            
            score += 1
            node.removeFromParent()
                
        } else if node.name == "teleport" {
            
            if isTeleporting == false {
               
                isTeleporting = true

                var newPosition = CGPoint(x: 0.0, y: 0.0)
                self.enumerateChildNodes(withName: "teleport") { teleNode, stop in
                    if teleNode.position != node.position {
                         newPosition = teleNode.position
                        print(newPosition)
                    }
                }
                
                player.physicsBody?.isDynamic = false

                let fade = SKAction.fadeAlpha(to: 0, duration: 0.2)
                let move = SKAction.move(to: newPosition, duration: 0.25)
                let fadeBack = SKAction.fadeAlpha(to: 1, duration: 0.2)

                let sequence = SKAction.sequence([fade, move, fadeBack])
                
                player.run(sequence)

                player.physicsBody?.isDynamic = true
                
            }
            
            
        } else if node.name == "finish" {
            currentLevel += 1
            // go to the next level
            removeAllChildren()
            loadLevel(level: currentLevel)
            createPlayer()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        // where the touched.
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }

        // only execute if running inside the simulator
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        // run on the device
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            
            // use tilt multiplier - tilt is very gentle
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
}

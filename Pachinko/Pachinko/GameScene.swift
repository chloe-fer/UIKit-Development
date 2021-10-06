//
//  GameScene.swift
//  Pachinko
//
//  Created by Chloe Fermanis on 3/10/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballLabel: SKLabelNode!
    
    let ballImages = ["ballRed", "ballBlue", "ballGrey", "ballCyan", "ballPurple", "ballYellow", "ballGreen"]
    
    var numberOfBalls = 5 {
        didSet {
            ballLabel.text = "Balls: \(numberOfBalls)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
            
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballLabel = SKLabelNode(fontNamed: "Futura")
        ballLabel.text = "Balls: 5"
        ballLabel.position = CGPoint(x: 400, y: 700)
        addChild(ballLabel)
        
        editLabel = SKLabelNode(fontNamed: "Futura")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        createSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        createSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        createSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        createSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        createBouncer(at: CGPoint(x: 0, y: 0))
        createBouncer(at: CGPoint(x: 256, y: 0))
        createBouncer(at: CGPoint(x: 512, y: 0))
        createBouncer(at: CGPoint(x: 768, y: 0))
        createBouncer(at: CGPoint(x: 1024, y: 0))
        
        physicsWorld.contactDelegate = self

    }
    
    func createBouncer(at position: CGPoint) {
        
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func createSlot(at position: CGPoint, isGood: Bool) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        var spin: SKAction
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"

            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            spin = SKAction.rotate(byAngle: .pi, duration: 10)

        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"

            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            spin = SKAction.rotate(byAngle: -.pi, duration: 10)

        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
                
        addChild(slotBase)
        addChild(slotGlow)
        
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            // tap location
            let location = touch.location(in: self)
            
            let objects = nodes(at: location) // nodes that exist at this location
            
            if objects.contains(editLabel) {
                
                editingMode.toggle()
                
            } else {
            
                if editingMode {
                    
                    print("Editing Mode: \(editingMode)")
                    
                    // create box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    
                    box.name = "box"
                    addChild(box)
                    
                } else {
                    
                    if numberOfBalls != 0 {
                        
                        // ball creation
                        let ball = SKSpriteNode(imageNamed: ballImages.randomElement() ?? "ballRed")
                        ball.name = "ball"

                        // let box = SKSpriteNode(color: .red, size:CGSize(width: 64, height: 64))
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody?.restitution = 0.4
                        
                        // detect collisions
                        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.categoryBitMask ?? 0
                        
                        // ball.position = location
                        
                        ball.position.x = location.x
                        ball.position.y = 700
                        
                        addChild(ball)
                                                
                    } else {

                        let gameOverLabel = SKLabelNode(fontNamed: "Futura")
                        gameOverLabel.fontSize = 60
                        gameOverLabel.text = "GAME OVER"
                        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
                        addChild(gameOverLabel)

                    }
                }
            }
            
        }
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            numberOfBalls -= 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            numberOfBalls -= 1
        } else if object.name == "box" {
            destroy(ball: object)
        }
    }
    
    func destroy(ball: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}

//
//  GameScene.swift
//  Project11
//
//  Created by diayan siat on 07/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var scoreLabel: SKLabelNode!
    var maxBalls = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            }else {
                editLabel.text = "Edit"
            }
        }
    }
    override func didMove(to view: SKView) {
        
        // SKSpriteNote is used to load images just like image view in UIKit
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace //the replace value means, draw, ignoring alpha values
        background.zPosition = -1 //this means draw this behind everything else
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self) //know the touch was made
        let objects = nodes(at: location)
        
        
        if objects.contains(editLabel) {
            //editingMode = !editingMode this line is the same as below
            editingMode.toggle()
        }else {
            
            if editingMode {
                //create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.name = "box"
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            }else {
                
                //create random balls
                let balls = ["ballGreen", "ballRed", "ballCyan", "ballGrey", "ballBlue", "ballPurple", "ballRed"]
                let randomBall = Int.random(in: 0...balls.count-1)
                
                let ball = SKSpriteNode(imageNamed: balls[randomBall]) //get ball image as ball
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0) //get the radius of the ball
                ball.physicsBody?.restitution = 0.4 //make ball bouncy
                //contactTestBitMask says: which collissions do you want to know about? (in this case everything)
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 //this says which nodes the ball should bounce into (everything)
                
                //if the y position is not at the top, do not create a ball
                if location.y > self.frame.midY && maxBalls != 5 {
                    ball.position = location //place the ball at the position that was touched
                    ball.name = "ball"
                    addChild(ball) //add the ball to the screen
                    maxBalls += 1
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        //create a spin action and rotate at 180 degress for 10secs
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) //pi == 180 degrees and measured in radians
        let spinForever = SKAction.repeatForever(spin) //spin forever the rotation
        slotGlow.run(spinForever)
    }
    
    func collision(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }else if object.name == "box" {
          object.removeFromParent()
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
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collision(ball: nodeA, object: nodeB)
        }else if nodeB.name == "ball" {
            collision(ball: nodeB, object: nodeA)
        }
    }
    
    
}

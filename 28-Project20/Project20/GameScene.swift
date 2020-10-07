//
//  GameScene.swift
//  Project20
//
//  Created by diayan siat on 04/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var launches = 0
    var maxLaunches = 10
    
    var gameTimer: Timer?
    var fireWorks = [SKNode]()
    
    var leftEdge = -22
    var bottomEdge = -22
    let rightEdge = 1024 + 22
    
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
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        // bonus: game over and restart
        gameOverLabel = SKLabelNode(fontNamed: "chalkduster")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.zPosition = 1
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 48
        newGameLabel = SKLabelNode(fontNamed: "chalkduster")
        newGameLabel.position = CGPoint(x: 512, y: 334)
        newGameLabel.horizontalAlignmentMode = .center
        newGameLabel.zPosition = 1
        newGameLabel.text = " NEW GAME "
        newGameLabel.name = "newGame"
        newGameLabel.fontSize = 28
        
        startGame()
    }
    
    // bonus: game over and restart
    func startGame() {
        score = 0
        gameOverLabel.removeFromParent()
        newGameLabel.removeFromParent()
        launches = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    // bonus: game over and restart
    func gameOver() {
        gameTimer?.invalidate()
        
        for node in fireWorks {
            node.removeFromParent()
        }
        
        addChild(gameOverLabel)
        addChild(newGameLabel)
    }
    
    //the X movement speed of the firework, plus X and Y positions for creation
    func createFireWorks(xMovement: CGFloat, x: Int, y: Int) {
        
        //create SKNode that acts as the firework container, positioned a the specified postion x and y
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        
        //create a rocket spritenode
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        //give the firework sprite one of three colors
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
            
        case 1:
            firework.color = .green
            
        case 2:
            firework.color = .red
            
        default:
            break
        }
        
        //create a bezier path that represents the movement of the firework
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        
        //tell the container node to follow that path turning itself as needed
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //Create particles behind the rocket to make it look like the fireworks are lit.
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        //add firework to fireworks array
        fireWorks.append(node)
        addChild(node)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        //The let node part creates a new constant called node, the case…as SKSpriteNode part means “if we can typecast this item as a sprite node, and of course the for loop is the loop itself.
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else {continue}
            
            for parent in fireWorks {
                guard let firework = parent.children.first as? SKSpriteNode else {continue}
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
        
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        launches += 1
        if launches >= maxLaunches {
            gameOver()
            return
        }
        
        switch Int.random(in: 0...3) {
            
        case 0:
            createFireWorks(xMovement: 0, x: 512, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            createFireWorks(xMovement: 0, x: 512, y: bottomEdge)
            createFireWorks(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireWorks(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireWorks(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFireWorks(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for(index, firework) in fireWorks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireWorks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let waitAction = SKAction.wait(forDuration: 2)
            let removeAction = SKAction.run { emitter.removeFromParent() }
            let sequence = SKAction.sequence([waitAction, removeAction])
            emitter.run(sequence)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numberExploded = 0
        
        for (index, fireworkContainer) in fireWorks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { return }
            
            if firework.name == "selected" {
                //destroy this firework
                explode(firework: firework)
                fireWorks.remove(at: index)
                numberExploded += 1
            }
        }
        
        
        switch numberExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}

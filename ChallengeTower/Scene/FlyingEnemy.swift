//
//  Enemy.swift
//  aa
//
//  Created by Matheus Costa on 13/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FlyingEnemy: SKSpriteNode {

    var target: Player!

    var stateMachine: GKStateMachine!
    var velocity : CGFloat = -40

    init(view: SKScene, target: Player) {
        let texture = SKTexture(imageNamed: "demonIdle1")
        var textures : [SKTexture] = []
        for i in 1 ... 6{
            textures.append(SKTexture(imageNamed: "demonIdle\(i)"))
        }
        
        
        
        super.init(texture: texture, color: .clear, size: texture.size())

        self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2)))
        
        view.addChild(self)

        self.target = target

        self.stateMachine = GKStateMachine(states: [
            IdleState(enemyNode: self),
            HuntingState(enemyNode: self),
            AtackingState(enemyNode: self)
        ])
        self.stateMachine.enter(IdleState.self)

        self.setupBody()

        
//        self.scene?.physicsWorld.contactDelegate = self
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 130, height: 100))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.mass = 100.0 // TODO: ver melhor essa propriedade
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false

        self.physicsBody?.fieldBitMask = ColliderType.none
        self.physicsBody?.categoryBitMask = ColliderType.hazard
        self.physicsBody?.collisionBitMask = ColliderType.player | ColliderType.ground | ColliderType.wall
        self.physicsBody?.contactTestBitMask = ColliderType.hazard | ColliderType.wall
        
        
        self.name = "Enemy"
        
        
    }

    func runAnimation(with frames: [SKTexture], withKey: String) {
        let animation = SKAction.animate(with: frames, timePerFrame: 0.2, resize: true, restore: false)
        self.run(SKAction.repeatForever(animation), withKey: withKey)
    }

    func stopAnimation(with key: String) {
        self.removeAction(forKey: key)
    }
    
    func die() {
        SKTAudio.sharedInstance().playSoundEffect("explosion.mp3")
        self.removeFromParent()
    }

    private func waitingForTarget() {
        let targetLocation = self.target.position

        // Checa na horizontal
        if targetLocation.x > self.position.x - 200 && targetLocation.x < self.position.x + 100 {
            // Checa na vertical
            if targetLocation.y > self.position.y - 170 && targetLocation.y < self.position.y + 50 {
                self.stateMachine.enter(HuntingState.self)
            }
        }
    }

    private func seekTarget() {
        let targetLocation = self.target.position

        // Aim
        if targetLocation.x < self.position.x {
            self.xScale = 1.0
        } else {
            self.xScale = -1.0
        }

        // Seek
        let dx = targetLocation.x - self.position.x
        let dy = targetLocation.y - self.position.y
        let angle = atan2(dy, dx)

        let vx = cos(angle) * 2.0
        let vy = sin(angle) * 2.0

        self.position.x += vx
        self.position.y += vy
    }

}

extension FlyingEnemy: Updatable {

    func update(currentTime: TimeInterval) {
        guard let currentState = self.stateMachine.currentState else { return }



//        self.physicsBody?.velocity.dx = 10
        if currentState is IdleState {
            self.waitingForTarget()
        } else if currentState is HuntingState {
            self.seekTarget()
        }

        self.physicsBody?.velocity.dx = velocity

//        print(self.size)
        
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.collisionBitMask == ColliderType.wall{
//            self.physicsBody?.velocity.dx *= -1
//        }
//        if contact.bodyB.collisionBitMask == ColliderType.wall{
//            self.physicsBody?.velocity.dx *= -1
//        }
//    }

}

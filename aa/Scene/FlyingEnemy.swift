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

class FlyingEnemy: SKNode {

    var target: Player!

    var stateMachine: GKStateMachine!

    var sprite: SKSpriteNode!

    init(view: SKScene, target: Player) {
        super.init()
        view.addChild(self)

        self.target = target

        self.stateMachine = GKStateMachine(states: [
            IdleState(enemyNode: self),
            HuntingState(enemyNode: self),
            AtackingState(enemyNode: self)
        ])
        self.stateMachine.enter(IdleState.self)

        self.setupBody()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBody() {
        self.sprite = SKSpriteNode(imageNamed: "personagem")
        self.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false

        // FIXME: Isso tá atrapalhando de alguma forma, precisa criar uma personalizado para o inimigo.
        self.physicsBody?.fieldBitMask = ColliderType.none
        self.physicsBody?.categoryBitMask = ColliderType.hazard
        self.physicsBody?.collisionBitMask = ColliderType.player | ColliderType.hazard | ColliderType.wall | ColliderType.ground
        self.physicsBody?.contactTestBitMask = ColliderType.player | ColliderType.hazard

        self.name = "Enemy"
        self.addChild(sprite)
    }

    private func waitingForTarget() {
        let targetLocation = self.target.position

        // Checa na horizontal
        if targetLocation.x > self.position.x - 10 &&
            targetLocation.x < self.position.x + 10 {

            self.stateMachine.enter(HuntingState.self)
        }
    }

    private func seekTarget() {
        let targetLocation = self.target.position

        // Aim
        if targetLocation.x < self.position.x {
            self.sprite.xScale = -1.0
        } else {
            self.sprite.xScale = 1.0
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
        print(currentState)
        if currentState is IdleState {
            self.waitingForTarget()
        } else if currentState is HuntingState {
            self.seekTarget()
        }
    }

}

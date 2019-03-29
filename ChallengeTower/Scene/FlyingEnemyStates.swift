//
//  FlyingEnemyStates.swift
//  aa
//
//  Created by Matheus Costa on 26/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import SpriteKit
import GameplayKit

class IdleState: GKState, SKPhysicsContactDelegate {
    var enemy: FlyingEnemy

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode
//        enemy.physicsBody?.velocity.dx = -10
        
        
    }

//    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.contactTestBitMask == ColliderType.wall{
//            enemy.physicsBody?.velocity.dx = (enemy.physicsBody?.velocity.dx)! * -1
//        }
//    }
    override func didEnter(from previousState: GKState?) {
        // trocar para animacao parado
    }
}

class HuntingState: GKState {
    var enemy: FlyingEnemy

    private var animationFrames: [SKTexture] = []

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode

        let atlas = SKTextureAtlas(named: "skull")
        var frames = [SKTexture]()
//
        for i in 1...atlas.textureNames.count {
            let textureName = "demonIdle\(i)"
            frames.append(atlas.textureNamed(textureName))
        }

        self.animationFrames = frames
    }

    override func didEnter(from previousState: GKState?) {
        self.enemy.runAnimation(with: self.animationFrames, withKey: "HuntingAnimation")
        print(self.animationFrames)
    }

    override func willExit(to nextState: GKState) {
        self.enemy.removeAction(forKey: "HuntingAnimation")
    }
}

class AtackingState: GKState {
    var enemy: FlyingEnemy

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode
    }

    override func didEnter(from previousState: GKState?) {
        // trocar para animacao atacando
    }
}

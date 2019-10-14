//
//  PhysicsDetection.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 22/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct ColliderType {
    static let none: UInt32 = UInt32.min // collide with all
    static let all: UInt32 = UInt32.max // collide with all
    static let player: UInt32 = 0x1 << 0 // 000000001 = 1
    static let ground: UInt32 = 0x1 << 1 // 000000010 = 2 // 000000100 = 4
    static let checkGround: UInt32 = 0x1 << 2
    static let gravity: UInt32 = 0x1 << 3
    static let wall: UInt32 = 0x1 << 4
    static let platform: UInt32 = 0x1 << 5
    static let hazard: UInt32 = 0x1 << 6
    static let sword: UInt32 = 0x1 << 7
    static let door: UInt32 = 0x1 << 8
}

class PhysicsDetection: NSObject, SKPhysicsContactDelegate {
    //var player: CharacterNode?
    
    func didBegin(_ contact: SKPhysicsContact) {

        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //if the collision was between player and ground
        if collision == ColliderType.player | ColliderType.ground {
            if let player = contact.bodyA.node as? Player {
                player.endStomp()
                player.ground()
            } else if let player = contact.bodyB.node as? Player{
                player.endStomp()
                player.ground()
            }
        }
        
    
        if collision == ColliderType.player | ColliderType.wall {
            let wallJump = { (player: Player, wall: SKSpriteNode) in
                player.wallJump()
            }
            if let player = contact.bodyA.node as? Player,
               let wall = contact.bodyB.node as? SKSpriteNode {
                wallJump(player,wall)
            } else if let player = contact.bodyB.node as? Player,
                      let wall = contact.bodyA.node as? SKSpriteNode {
                wallJump(player, wall)
            }
        }
        
        if collision == ColliderType.player | ColliderType.platform {
            let action = { (player: Player, platform: Platform) in
                if player.position.y > platform.sprite.position.y {
                    player.endStomp()
                    player.ground()
                }
            }
            if let player = contact.bodyA.node as? Player,
                let platform = contact.bodyB.node as? Platform {
                action(player, platform)
            } else if let player = contact.bodyB.node as? Player,
                let platform = contact.bodyA.node as? Platform {
                action(player, platform)
            }
        }
        
        if collision == ColliderType.player | ColliderType.hazard {
            if let player = contact.bodyA.node as? Player {
                player.receiveDamage(percentage: 100)
            } else if let player = contact.bodyB.node as? Player{
                player.receiveDamage(percentage: 100)
            }
        }
        
        if collision == ColliderType.wall | ColliderType.hazard{
            if let enemy =  contact.bodyA.node as? FlyingEnemy{
                enemy.velocity *= -1
                enemy.xScale *= -1
                
            }
            else if let enemy = contact.bodyB.node as? FlyingEnemy{
                enemy.velocity *= -1
                enemy.xScale *= -1
            }
        }

        if collision == ColliderType.player | ColliderType.door {
            if let player = contact.bodyA.node as? Player {
                let scene = player.scene as? GameScene
                scene?.resetPhase()
            } else if let player = contact.bodyB.node as? Player{
                let scene = player.scene as? GameScene
                scene?.resetPhase()
            }
        }
        
        if collision == ColliderType.sword | ColliderType.hazard {
            if let enemy = contact.bodyA.node as? FlyingEnemy,
                let sword = contact.bodyB.node as? Sword {
                enemy.die()
                sword.removeFromParent()
            } else if let enemy = contact.bodyB.node as? FlyingEnemy,
                let sword = contact.bodyA.node as? Sword {
                enemy.die()
                sword.removeFromParent()
            }
        }
        
        if (collision == ColliderType.sword | ColliderType.ground)
        || (collision == ColliderType.sword | ColliderType.platform) {
            if let sword = contact.bodyA.node as? Sword {
                sword.physicsBody?.contactTestBitMask = ColliderType.sword
            } else if let sword = contact.bodyB.node as? Sword {
                sword.physicsBody?.contactTestBitMask = ColliderType.sword
            }
        }
        
        if collision == ColliderType.player | ColliderType.player {
            print("collision between players")
        }
        if collision == ColliderType.checkGround | ColliderType.ground {
            print("collision between check")
        }
        
    }
    
}

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
}

class PhysicsDetection: NSObject, SKPhysicsContactDelegate {
    //var player: CharacterNode?
    
    func didBegin(_ contact: SKPhysicsContact) {
//        print("bodyA:", contact.bodyA.node?.name ?? "nil", "bodyB: ", contact.bodyB.node?.name ?? "nil")
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //if the collision was between player and ground
        if collision == ColliderType.player | ColliderType.ground {
            if let player = contact.bodyA.node as? Player {
                player.grounded = true
            } else if let player = contact.bodyB.node as? Player{
                player.grounded = true
            }
        }
        
    
        if collision == ColliderType.player | ColliderType.wall {
            let wallJump = { (player: Player, wall: SKSpriteNode) in
                player.wallJump()
                wall.physicsBody?.friction = 0.1
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
                if let velocity = player.physicsBody?.velocity.dy {
                    if (velocity > 0 && player.position.y < platform.sprite.position.y)
                    || (player.position.y < platform.sprite.position.y && player.isPlatforming) {
                        if player.isPlatforming { player.physicsBody?.velocity.dy = 500 }
                        player.physicsBody?.collisionBitMask &= ~ColliderType.platform
                        player.willPlatform = true
                    } else {
                        player.physicsBody?.collisionBitMask |= ColliderType.platform
                        player.isPlatforming = true
                    }
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
        
        if collision == ColliderType.player | ColliderType.player {
            print("collision between players")
        }
        if collision == ColliderType.checkGround | ColliderType.ground {
            print("collision between check")
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.platform | ColliderType.player {
            let action = { (player: Player, platform: Platform) in
                if let velocity = player.physicsBody?.velocity.dy {
                    if (velocity > 0 && player.position.y < platform.sprite.position.y)
                    || (player.position.y < platform.sprite.position.y && player.isPlatforming) {
                        if player.willPlatform {
                            player.physicsBody?.collisionBitMask |= ColliderType.platform
                            player.isPlatforming = true
                            player.willPlatform = false
                        }
                    } else {
                        if player.willPlatform || player.isFallingFromWallJump {
                            player.physicsBody?.collisionBitMask |= ColliderType.platform
                            player.isPlatforming = true
                            player.willPlatform = false
                        } else if player.isFalling {
                            player.physicsBody?.collisionBitMask |= ColliderType.platform
                            player.isPlatforming = true
                            player.isFalling = false
                        }
                    }
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
    }
    
}

enum PlatformCollisionStates {
    case beganPassingUp
    case endedPassingUp
    case platformed
    case beganFallingDown
    case endedFallingDown
}

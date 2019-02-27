//
//  Player.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKNode, Updatable, MoveControllable {
    
    var sprite = SKSpriteNode()
    var checkFloor = SKSpriteNode()
    var isWalking = false
    
    var lastSpeed = CGFloat(0)
    var lastDirection = CGVector(dx: 1, dy: 0)
    
    var maxNJumps = 2
    var nJumps = 0 {
        didSet {
            if nJumps >= maxNJumps {
                canJump = false
            }
        }
    }
    
    var isWallJumping = false {
        didSet {
            if isWallJumping { canJump = true }
        }
    }
    
    var isFallingFromWallJump = false {
        didSet {
            if !isWallJumping { isFallingFromWallJump = false }
            if isFallingFromWallJump {
                let scene = self.scene as? GameScene
                scene?.gravityField.strength = 9.8
            }
        }
    }
    
    var grounded = true {
        didSet{
            if grounded {
                canJump = true
                isWallJumping = false
                isFallingFromWallJump = false
                physicsBody?.velocity.dx = lastSpeed
                let scene = self.scene as? GameScene
                scene?.gravityField.strength = 9.8
            }
            
        }
    }
    
    var canJump = true {
        didSet{
            if canJump {
                nJumps = 0
            }
        }
    }
    
    var willDash = false
    var isDashing = false {
        didSet {
            if isDashing {
                Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { _ in
                    if self.lastDirection.dy >= 0 { self.physicsBody?.velocity = self.lastDirection.normalized() * self.lastSpeed }
                    self.physicsBody?.fieldBitMask = ColliderType.gravity
                    self.isDashing = false
                    self.isInDashCooldown = true
                }
            }
        }
    }
    
    var isInDashCooldown = false {
        didSet {
            if isInDashCooldown {
                Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { _ in
                    self.isInDashCooldown = false
                }
            }
        }
    }
    
    override init() {
        super.init()
        let playerTexture = SKTexture(imageNamed: "player")
        self.sprite = SKSpriteNode(texture: playerTexture, color: .black, size: CGSize(width: 20, height: 30))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 30))
        self.physicsBody?.friction = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.fieldBitMask = ColliderType.gravity
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.addChild(sprite)
        
    }
    
    func update(currentTime: TimeInterval) {
        // your logic goes here
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWalking(direction: CGPoint, withVelocity velocity: CGFloat = 5) {
        self.physicsBody?.velocity.dx = direction.x * velocity
        let xScale = direction.x > 0 ? 1 : -1
        self.sprite.xScale = CGFloat(xScale)
        self.lastSpeed = velocity
        self.isWalking = true
    }
    
    func stopWalking() {
        self.physicsBody?.velocity.dx = 0
        self.lastDirection.dy = 0
        self.lastSpeed = 0
        self.isWalking = false
    }
    
    func jump() {
        if self.canJump {
            if isWallJumping {
                self.isFallingFromWallJump = true
                self.nJumps = 2
            } else {
                self.nJumps += 1
            }
            
            self.grounded = false
            self.physicsBody?.velocity.dy = 0
            self.physicsBody?.applyForce(CGVector.up * CGFloat(800))
        }
    }
    
    func wallJump() {
        if !self.grounded {
            self.isWallJumping = true
            self.isFallingFromWallJump = false
            self.physicsBody?.velocity.dy = 0
            let scene = self.scene as? GameScene
            scene?.gravityField.strength = 1
        }
    }
    
    func pointOfDashImpulse() -> CGPoint {
        let minX = self.position.x - self.sprite.frame.width/2
        let minY = self.position.y - self.sprite.frame.height/2
        let maxX = self.position.x + self.sprite.frame.width/2
        let maxY = self.position.y + self.sprite.frame.height/2
        
        let x = lastDirection.dx > 0 ? minX : maxX
        let y = lastDirection.dy > 0 ? minY : maxY
        
        return CGPoint(x: x, y: y)
    }
    
    func dash() {
        if !self.isDashing && !self.isInDashCooldown {
            self.willDash = true
            let impulseVector = CGVector(dx: lastDirection.normalized().dx * 1200, dy: lastDirection.dy * 24)
            if isWallJumping {
                let xScale = impulseVector.dx > 0 ? 1 : -1
                self.sprite.xScale = CGFloat(xScale)
                self.isFallingFromWallJump = true
            }
            self.physicsBody?.applyForce(impulseVector, at: pointOfDashImpulse())
            self.physicsBody?.fieldBitMask = ColliderType.none
            if lastDirection.dy >= 0 { self.physicsBody?.velocity.dy = 0 }
            self.willDash = false
            self.isDashing = true
        }
    }
    
    func move(for velocity: CGPoint) {
        if lastDirection != velocity {
            self.lastDirection = CGVector(dx: velocity.x, dy: velocity.y)
        }
        
        if (self.willDash)
        || (!self.isDashing && !self.isWallJumping)
        || (self.isWallJumping && self.isFallingFromWallJump) {
            self.startWalking(direction: velocity)
        }
    }
    
    func stopMoving() {
        self.stopWalking()
    }
    
}



typealias Vector2D = CGVector

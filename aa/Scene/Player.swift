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
    
    var isWallJumping = false {
        didSet {
            if isWallJumping { canJump = true }
        }
    }
    
    var lastSpeed = CGFloat(0)
    var lastDirection = CGVector(dx: 1, dy: 0)
    
    var maxNJumps = 2
    var nJumps = 0{
        didSet {
            if(nJumps>=maxNJumps){
                canJump = false
            }
        }
    }
    
    var grounded = true {
        didSet{
            if(grounded){
                canJump = true
            }
            
        }
    }
    
    var canJump = true {
        didSet{
            if(canJump){
                nJumps = 0
            }
        }
    }
    
    var isDashing = false {
        didSet {
            if isDashing {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
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
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
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
        if lastDirection != direction { self.lastDirection = CGVector(dx: direction.x, dy: direction.y) }
    }
    
    func stopWalking() {
        self.physicsBody?.velocity.dx = 0
        self.lastDirection.dy = 0
        self.lastSpeed = 0
        self.isWalking = false
    }
    
    func jump() {
        if self.canJump {
            self.physicsBody?.velocity.dy = 0
            self.physicsBody?.applyForce(CGVector.up * CGFloat(800))
            if !isWallJumping {
                nJumps = nJumps + 1
            } else {
                nJumps = 2
                isWallJumping = false
            }
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
            let impulseVector = lastDirection.normalized() * 1400
            self.physicsBody?.applyForce(impulseVector, at: pointOfDashImpulse())
            self.physicsBody?.fieldBitMask = ColliderType.none
            if lastDirection.dy >= 0 { self.physicsBody?.velocity.dy = 0 }
            self.isDashing = true
        }
    }
    
    func move(for velocity: CGPoint) {
        if !self.isDashing {
            self.startWalking(direction: velocity)
        }
    }
    
    func stopMoving() {
        self.stopWalking()
    }
    
}



typealias Vector2D = CGVector

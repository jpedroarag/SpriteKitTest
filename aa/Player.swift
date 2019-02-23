//
//  Player.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKNode, Updatable{
    
    var sprite = SKSpriteNode()
    var checkFloor = SKSpriteNode()
    var isWalking = false
    
    var lastSpeed = CGFloat(0)
    var lastDirection = CGVector(dx: 1, dy: 1) {
        didSet {
            self.sprite.xScale *= -1
        }
    }
    
    var maxNJumps = 2
    var nJumps = 0{
        didSet{
            if(nJumps>=maxNJumps){
                canJump = false
            }
        }
    }
    
    var grounded = true{
        didSet{
            if(grounded){
                canJump = true
            }
            
        }
    }
    
    var canJump = true{
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
                    self.physicsBody?.velocity.dx = self.lastSpeed * self.lastDirection.dx
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
    
    func startWalking(direction: CGPoint, withVelocity velocity: CGFloat = 300){
        self.physicsBody?.velocity.dx = direction.x * velocity
        self.lastSpeed = velocity
        self.isWalking = true
        if lastDirection.dx != direction.x { self.lastDirection.dx = direction.x }
    }
    
    func stopWalking() {
        self.physicsBody?.velocity.dx = 0
        self.lastSpeed = 0
        self.isWalking = false
    }
    
    func jump(){
        if self.canJump {
            nJumps = nJumps + 1
            self.physicsBody?.velocity.dy = 0
            self.physicsBody?.applyForce(CGVector.up * CGFloat(600))
        }
    }
    
    func dash() {
        if !self.isDashing && !self.isInDashCooldown {
            let direction = CGVector(dx: lastDirection.dx * 15, dy: 0)
            self.physicsBody?.applyImpulse(direction)
            self.physicsBody?.fieldBitMask = ColliderType.none
            self.physicsBody?.velocity.dy = 0
            self.isDashing = true
        }
    }
    
}



typealias Vector2D = CGVector

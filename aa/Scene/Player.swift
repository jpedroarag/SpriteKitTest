//
//  Player.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKNode, Updatable, MoveControllable, RotateControllable {
    
    func rotate(for angularVelocity: CGFloat) {
        if(angularVelocity.magnitude < 0){
            return
        }
        
        let direction = CGPoint(angle: angularVelocity + 90 * CGFloat.degreesToRadians)
        aim(direction: direction)
        print(angularVelocity)
    }
    
    
    var pool: Pool<Sword>!
    
    
    
    var joint = SKPhysicsJointPin()
    var gunArm = SKSpriteNode()
    var sword = SKSpriteNode()
    
    let shootCoolDown = 0.15
    let swordLifeTime = 2.0
    
    var sprite = SKSpriteNode()
    var checkFloor = SKSpriteNode()
    var isWalking = false
    
    var lastSpeed = CGFloat(0)
    var lastDirection = CGVector(dx: 30, dy: 0)
    
    var maxNJumps = 2
    var nJumps = 0 {
        didSet {
            if nJumps >= maxNJumps {
                canJump = false
            }
        }
    }
    var canShoot = true{
        didSet{
            if(!canShoot){
                Timer.scheduledTimer(withTimeInterval: shootCoolDown, repeats: false, block: {_ in self.canShoot = true})
            }
        }
    }
    
    var facedDirection = 1{
        didSet{
            changeDirection()
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
                isWallJumping = false
                physicsBody?.velocity.dx = lastSpeed
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
                    if self.lastDirection.dy >= 0 { self.physicsBody?.velocity.dx = self.lastDirection.normalized().dx * self.lastSpeed }
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
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.isInDashCooldown = false
                }
            }
        }
    }
    
    init(addToView view: SKScene) {
        super.init()
//        let playerTexture = SKTexture(imageNamed: "player")
//        self.sprite = SKSpriteNode(texture: playerTexture, color: .black, size: CGSize(width: 20, height: 30))
//        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 30))
//        self.physicsBody?.friction = 0
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.restitution = 0
//        self.physicsBody?.fieldBitMask = ColliderType.gravity
//        self.physicsBody?.categoryBitMask = ColliderType.player
        view.addChild(self)

        
        setupBody()
        setupArm()
        setupJoint()
        setupWeapon()

        
        pool = Pool(instanceType: Sword(texture: SKTexture(imageNamed: "Sword"), color: .white, size: CGSize(width: 10, height: 40), lifeTime: swordLifeTime, scene: nil), poolSize: 20, canGrow: false)
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
        self.facedDirection = xScale
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
    
    func dashDirection() -> CGVector {
        
        let scene = self.scene as? GameScene
        var angularVelocity: CGFloat = 90
        
        if let scene = scene {
            angularVelocity = -scene.inputController.joystick.angularVelocity * CGFloat.radiansToDegrees
        }
        
        // 1o quadrante
        if angularVelocity >= 0 && angularVelocity <= 90 {
            
            let middleAngle: CGFloat = (0 + 90)/2
            angularVelocity = (angularVelocity - middleAngle) < 0 ? 0 : 90
            
        }
        
        // 2o quadrante
        else if angularVelocity >= 90 && angularVelocity <= 180 {
            
            let middleAngle: CGFloat = (90 + 180)/2
            angularVelocity = (angularVelocity - middleAngle) < 0 ? 90 : 180
            
        }
        
        // 3o quadrante
        else if angularVelocity >= -180 && angularVelocity <= -90 {
            
            let middleAngle: CGFloat = (-180 - 90)/2
            angularVelocity = (angularVelocity - middleAngle) < 0 ? -180 : -90
            
        }
        
        // 4o quadrante
        else if angularVelocity >= -90 && angularVelocity <= 0 {
            
            let middleAngle: CGFloat = (-90 - 0)/2
            angularVelocity = (angularVelocity - middleAngle) < 0 ? -90 : 0
            
        }
        
        if abs(angularVelocity) == 0 {
            lastDirection = .zero
        } else if abs(angularVelocity) == 180 {
            lastDirection.dx = 0
            lastDirection.dy = -70
        } else if abs(angularVelocity) == 90 {
            lastDirection.dy = 0
        }
        
        if (lastDirection.dx < 30 && lastDirection.dx > 0) || (lastDirection == .zero && facedDirection == 1) {
            lastDirection.dx = 30
        } else if (lastDirection.dx > -30 && lastDirection.dx < 0) || (lastDirection == .zero && facedDirection == -1) {
            lastDirection.dx = -30
        }
        
        return lastDirection
        
    }
    
    func dash() {
        if !self.isDashing && !self.isInDashCooldown {
            self.willDash = true
            let direction = dashDirection()
            let impulseVector = direction * 24
            if isWallJumping {
                let xScale = impulseVector.dx > 0 ? 1 : -1
                self.facedDirection = xScale
                self.sprite.xScale = CGFloat(xScale)
                self.isFallingFromWallJump = true
            }
            self.physicsBody?.fieldBitMask = ColliderType.none
            self.physicsBody?.applyForce(impulseVector)
            if lastDirection.dy >= 0 && lastDirection.dx != 0 { self.physicsBody?.velocity.dy = 0 }
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
    
    
    func setupBody(){
        sprite = SKSpriteNode(imageNamed: "Knight")
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        //self.physicsBody?.friction = 0
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.fieldBitMask = ColliderType.gravity
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.wall
        self.physicsBody?.contactTestBitMask = ColliderType.player
        self.name = "Player"
        self.addChild(sprite)
    }
    
    func setupArm(){
        gunArm = SKSpriteNode()
        gunArm.position.x = 10
        gunArm.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 5))
        gunArm.physicsBody?.affectedByGravity = false
        gunArm.physicsBody?.friction = 0
        gunArm.physicsBody?.collisionBitMask = ColliderType.none
        gunArm.physicsBody?.categoryBitMask = ColliderType.none
        gunArm.physicsBody?.contactTestBitMask = ColliderType.none
        gunArm.physicsBody?.allowsRotation = false
        self.addChild(gunArm)
    }
    
    func setupJoint(){
        joint = SKPhysicsJointPin.joint(withBodyA: (self.physicsBody)!, bodyB: gunArm.physicsBody!, anchor: CGPoint(x: 0.0, y: 0.0))
        
        joint.shouldEnableLimits = false
        joint.frictionTorque = 0
        //joint.rotationSpeed = 1
        
        scene?.physicsWorld.add(joint)
    }
    
    func throwSword(rotation: CGFloat, direction: CGPoint){
        
        //let sword = Sword(texture: SKTexture(imageNamed: "Sword"), color: .white, size: CGSize(width: 10, height: 40), lifeTime: swordLifeTime, scene: self.scene)
        let sword = pool.get()!
        self.scene?.addChild(sword)
        
        sword.throwSword(position: self.position, rotation: rotation, speed: 1000)
        
        sword.destroy()
        
    }
    
    func setupWeapon(){
        sword = SKSpriteNode(imageNamed: "Sword")
        sword.position.x = 00
        gunArm.addChild(sword)
    }
    
    
    func aim(direction: CGPoint) {
        let angle = (atan2(direction.x, -direction.y))
        gunArm.zRotation =  angle - (90 * CGFloat.degreesToRadians)
        
        if (angle * CGFloat.radiansToDegrees > 0) {
            facedDirection = 1
            
        } else {
            facedDirection = -1
        }
        
        if (facedDirection == -1 && lastDirection.dx > 0)
        || (facedDirection == 1 && lastDirection.dx < 0) {
//             lastDirection.dx *= -1
        }
        
        if(canShoot){
            canShoot = false
            throwSword(rotation: gunArm.zRotation, direction: direction)
        }
        
    }
    
    func cancelAim(){
        //changeDirection()
    }
    
    func changeDirection(){
        let angle = gunArm.zRotation * CGFloat.radiansToDegrees + 90
        let angle2 = ((-angle) - 90) * CGFloat.degreesToRadians
        
        sprite.xScale = (sprite.xScale).magnitude
        gunArm.yScale = (gunArm.yScale).magnitude
        
        if(facedDirection < 0){
            
            sprite.xScale = sprite.xScale * -1
            gunArm.yScale = gunArm.yScale * -1
            if( (angle) > 0 && angle < 180){
                gunArm.zRotation = angle2
            }
            
        }else{
            if(angle < 0 || angle > 180){
                gunArm.zRotation =  angle2
            }
        }
    }

    
}



typealias Vector2D = CGVector

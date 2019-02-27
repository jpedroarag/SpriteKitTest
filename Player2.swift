//
//  Player.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//



import Foundation
import SpriteKit

class Player2: SKNode, Updatable{
    
    var pool: Pool<Sword>!
    
    
    var sprite = SKSpriteNode()
    var joint = SKPhysicsJointPin()
    var gunArm = SKSpriteNode()
    var sword = SKSpriteNode()
    var maxNJumps = 2
    
    let shootCoolDown = 0.15
    let swordLifeTime = 2.0
    
    
    
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
    
    init(addToView view: SKScene){
        super.init()
        view.addChild(self)
        
        setupBody()
        setupArm()
        setupJoint()
        setupWeapon()
        
        pool = Pool(instanceType: Sword(texture: SKTexture(imageNamed: "Sword"), color: .white, size: CGSize(width: 10, height: 40), lifeTime: swordLifeTime, scene: nil), poolSize: 20, canGrow: false)
    }
    
    func setupBody(){
        sprite = SKSpriteNode(imageNamed: "Knight")
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.collisionBitMask = ColliderType.ground
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
    
    func update(currentTime: TimeInterval) {
        // your logic goes here
    }
    

    func aim(direction: CGPoint){
        let angle = (atan2(direction.x, -direction.y))
        gunArm.zRotation =  angle - (90 * CGFloat.degreesToRadians)

        if( angle * CGFloat.radiansToDegrees > 0){
            facedDirection = 1
        }else{
            facedDirection = -1
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk(direction: CGPoint){
        facedDirection = Int(direction.x)
        self.position = position + (direction * 30)
        
    }
    
    func jump(){
        if self.canJump {
            nJumps = nJumps + 1
            self.physicsBody?.velocity.dy = 0
            self.physicsBody?.applyForce(CGVector.up * CGFloat(600))
        }
    }
    
    
   
}



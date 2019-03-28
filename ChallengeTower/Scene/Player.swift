//
//  Player.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: Dash flags and constants
struct DashValues {
    /// The duration of player's dash
    let duration = 0.15
    
    /// The duration which the player won't be able to dash again
    let cooldown = 0.3
    
    /// Tells if the player will dash soon
    var willDash = false
    
    /// Tells if the player is currently dashing
    var isDashing = false
    
    /// Tells if the player has dashed and isn't able to dash right now
    var isCooldownling = false
    
    /// Resets all dash values to their initial value
    mutating func resetToInitialState() {
        willDash = false
        isDashing = false
        isCooldownling = false
    }
    
}

// MARK: Platforms and ground flags and constants
struct LandValues {
    
    /// Default platforms height
    static let platformsHeight: CGFloat = 32
    
    /// Tells if the player is getting up in a platform
    var willLand = false
    
    /// Tells if the player is currently landed on a platform which is not the ground
    var landed = false
    
    /// Tells if the player will fall from the platform which he is landed soon
    var willUnland = false
    
    /// Tells if the player fell from the platform which he was landed
    var isUnlanding = false
    
    /// Tells if the player is currently landed on the ground of the scene
    var grounded = true
    
    /// Resets all land values to their initial value
    mutating func resetToInitialState() {
        willUnland = false
        isUnlanding = false
        willLand = false
        landed = false
        grounded = true
    }
    
}

// MARK: Jump flags and constants
struct JumpValues {
    /// The maximum times which the player can jump
    let maxNumberOfJumps = 2
    
    /// How many times the player has jumped
    var numberOfJumps = 0
    
    /// Tells if the user can jump
    var canJump = true
    
    /// Tells if the user is currently jumping
    var isJumping = false
    
    /// Resets all jump values to their initial value
    mutating func resetToInitialState() {
        numberOfJumps = 0
        canJump = true
        isJumping = false
    }
    
}

// MARK: Wall jump flags and constants
struct WallJumpValues {
    /// Tells if the player is currently attached to the wall, waiting for the user to use his wall jump
    var isWallJumping = false
    
    /// Tells if the user used his wall jump, and is currently in the air
    var isFallingFromWallJump = false
    
    /// Resets all wall jump values to their initial value
    mutating func resetToInitialState() {
        isWallJumping = false
        isFallingFromWallJump = false
    }
    
}

// MARK: Direction flags and constants
struct DirectionValues {
    /// Tells which side the player is looking for (1 = right, -1 = left)
    var facedDirection = 1
    
    /// Tells if the user is currently walking
    var isWalking = false
    
    /// Holds the last speed the user had before his current speed
    var lastSpeed = CGFloat(0)
    
    /// Holds the last direction the user had before his current direction
    var lastDirection = CGVector(dx: 30, dy: 0)
}

// MARK: Combat flags and constants
struct CombatValues {
    /// The duration which the player won't be able to shoot again
    let shootCoolDown = 0.15
    
    /// The time which the sword will exists
    let swordLifeTime = 2.0
    
    /// Tells if the user can shoot
    var canShoot = true
    
    /// How many Health Points the player have
    var hp = 100 {
        didSet {
            if hp > 100 { hp = 100 }
            if hp < 0 { hp = 0 }
        }
    }
    
    /// Tells if the user is dead
    var isDead = false
    
    mutating func resetToInitialState() {
        canShoot = true
        hp = 100
        isDead = false
    }
}

// MARK: Player class definition
class Player: SKNode {
    
    // MARK: Properties
    var pool: Pool<Sword>!
    
    var joint = SKPhysicsJointPin()
    var gunArm = SKSpriteNode()
    var sword = SKSpriteNode()
    
    var sprite = SKSpriteNode()
    var checkFloor = SKSpriteNode()
    
    // MARK: All flags and constants
    
    /// Holds the player's properties related to the dash action
    var dashValues = DashValues()
    /// Holds the player's properties related to land in a platform or on the ground
    var landValues = LandValues()
    /// Holds the player's properties related to the jump action
    var jumpValues = JumpValues()
    /// Holds the player's properties related to the wall jump action
    var wallJumpValues = WallJumpValues()
    /// Holds the player's properties related to his orientation attributes
    var directionValues = DirectionValues()
    /// Holds the player's properties related to the combat actions
    var combatValues = CombatValues()
    
    /// Holds how strong the scene gravity affects the player
    var gravityStrength: Float? {
        get {
            let scene = self.scene as? GameScene
            return scene?.gravityField.strength
        }
        set(value) {
            if let value = value, let scene = scene as? GameScene { scene.gravityField.strength = value }
        }
    }
    
    // MARK: Init
    init(addToView view: SKScene) {
        super.init()
        view.addChild(self)
        
        setupBody()
        setupArm()
        setupJoint()
        setupWeapon()
        
        let sword = Sword(texture: SKTexture(imageNamed: "Sword"),
                          color: .white,
                          size: CGSize(width: 10, height: 40),
                          lifeTime: combatValues.swordLifeTime,
                          scene: nil)
        
        pool = Pool(instanceType: sword, poolSize: 20, canGrow: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Setup of player and player's weapon
extension Player {
    func setupBody(){
        sprite = SKSpriteNode(imageNamed: "Knight")
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.fieldBitMask = ColliderType.gravity
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.wall | ColliderType.platform | ColliderType.hazard
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
    
    func setupWeapon(){
        sword = SKSpriteNode(imageNamed: "Sword")
        sword.position.x = 00
        gunArm.addChild(sword)
    }
}

// MARK: Player orientation methods
extension Player {
    func flip(toTheRight right: Bool) {
        let xScale = right ? 1 : -1
        self.directionValues.facedDirection = xScale
        self.changeDirection()
    }
    
    func changeDirection(){
        let angle = gunArm.zRotation * CGFloat.radiansToDegrees + 90
        let angle2 = (-angle - 90) * CGFloat.degreesToRadians
        
        sprite.xScale = sprite.xScale.magnitude
        gunArm.yScale = gunArm.yScale.magnitude
        
        if(directionValues.facedDirection < 0){
            sprite.xScale = sprite.xScale * -1
            gunArm.yScale = gunArm.yScale * -1
            if angle > 0 && angle < 180 {
                gunArm.zRotation = angle2
            }
        } else {
            if angle < 0 || angle > 180 {
                gunArm.zRotation =  angle2
            }
        }
    }
}

// MARK: Methods for when collides with ground or platforms
extension Player {
    func resetVelocity() {
        physicsBody?.velocity.dx = directionValues.lastSpeed
        gravityStrength = 9.8
    }
    
    func turnCollisionWithPlatforms(on: Bool) {
        if on {
            physicsBody?.collisionBitMask |= ColliderType.platform
        } else {
            physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.wall
        }
    }
    
    func land() {
        turnCollisionWithPlatforms(on: true)
        resetVelocity()
        landValues.landed = true
        landValues.willUnland = false
        landValues.isUnlanding = false
        landValues.grounded = false
        landValues.willLand = false
        jumpValues.canJump = true
        jumpValues.numberOfJumps = 0
        wallJumpValues.resetToInitialState()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if self.landValues.landed { self.jumpValues.isJumping = false }
        }
    }
    
    func unland() {
        landValues.isUnlanding = true
        landValues.landed = false
        landValues.willUnland = false
        turnCollisionWithPlatforms(on: false)
    }
    
    func ground() {
        resetVelocity()
        landValues.resetToInitialState()
        wallJumpValues.resetToInitialState()
        jumpValues.resetToInitialState()
    }
}

// MARK: Jump action implementation
extension Player {
    func jump() {
        if self.wallJumpValues.isWallJumping {
            self.wallJumpValues.isFallingFromWallJump = true
            self.wallJumpValues.isWallJumping = false
            self.resetVelocity()
        }
        
        if !jumpValues.canJump {
            self.jumpValues.isJumping = false
            return
        }
        
        self.landValues.grounded = false
        self.jumpValues.isJumping = true
        self.jumpValues.numberOfJumps += 1
        if self.jumpValues.numberOfJumps >= self.jumpValues.maxNumberOfJumps { self.jumpValues.canJump = false }
        self.physicsBody?.velocity.dy = 0
        self.physicsBody?.applyForce(CGVector.up * CGFloat(700))
        self.run(.playSoundFileNamed("jump.wav", waitForCompletion: false))
    }
    
    func wallJump() {
        if self.landValues.grounded { return }
        
        self.wallJumpValues.isWallJumping = true
        self.wallJumpValues.isFallingFromWallJump = false
        
        self.jumpValues.canJump = true
        self.landValues.resetToInitialState()
        
        self.physicsBody?.velocity.dy = 0
        self.gravityStrength = 2.5
    }
}

// MARK: Walking move action implementation
extension Player {
    func startWalking(direction: CGPoint, withVelocity velocity: CGFloat = 5) {
        self.flip(toTheRight: direction.x > 0)
        self.physicsBody?.velocity.dx = direction.x * velocity
        self.directionValues.lastSpeed = velocity
        self.directionValues.isWalking = true
    }
}

// MARK: Dash action implementation
extension Player {
    // This function is currently unused
    private func getDashDirection() -> CGVector {
        let scene = self.scene as? GameScene
        var angularVelocity: CGFloat = 90
        let ranges = [0...90, 90...180, -180...(-90), -90...0]
        
        if let scene = scene {
            angularVelocity = -scene.inputController.joystick.angularVelocity * CGFloat.radiansToDegrees
        }
        
        for range in ranges {
            if range.contains(Int(angularVelocity)) {
                let middleAngle: CGFloat = CGFloat(range.lowerBound + range.upperBound)/2
                let angle = (angularVelocity - middleAngle) < 0 ? range.lowerBound : range.upperBound
                angularVelocity = CGFloat(angle)
            }
        }
        
        switch abs(angularVelocity) {
        case 0:
            directionValues.lastDirection = .zero
        case 90:
            directionValues.lastDirection.dy = 0
        case 180:
            directionValues.lastDirection.dx = 0
            directionValues.lastDirection.dy = -70
            if landValues.landed && !jumpValues.isJumping {
                landValues.willUnland = true
                // Gambiarra: Fazendo colidir manualmente,
                // pois como a plataforma tem restitution = 0,
                // ele não colide com a plataforma quando usa o dash para baixo
                run(.moveTo(y: position.y - LandValues.platformsHeight, duration: 0.1))
            }
            if landValues.grounded && !jumpValues.isJumping { directionValues.lastDirection = .zero }
        default:
            break
        }
        
        validateDashDirectionValue()
        return directionValues.lastDirection
        
    }
    
    private func validateDashDirectionValue() {
        if (directionValues.lastDirection.dx < 30 && directionValues.lastDirection.dx > 0)
            || (directionValues.lastDirection == .zero && directionValues.facedDirection == 1) {
            directionValues.lastDirection.dx = 30
        }
        
        if (directionValues.lastDirection.dx > -30 && directionValues.lastDirection.dx < 0)
            || (directionValues.lastDirection == .zero && directionValues.facedDirection == -1) {
            directionValues.lastDirection.dx = -30
        }
    }
    
    func dash() {
        if !self.dashValues.isDashing && !self.dashValues.isCooldownling {
            validateDashDirectionValue()
            let impulseVector = CGVector(dx: directionValues.lastDirection.dx * 24, dy: 0)
            
            self.dashValues.willDash = true
            if self.wallJumpValues.isWallJumping {
                self.flip(toTheRight: impulseVector.dx > 0)
                self.wallJumpValues.isFallingFromWallJump = true
                self.wallJumpValues.isWallJumping = false
                self.resetVelocity()
            }
            
            self.physicsBody?.fieldBitMask = ColliderType.none
            self.physicsBody?.applyForce(impulseVector)
            self.run(.playSoundFileNamed("dash.mp3", waitForCompletion: false))
            self.dashValues.willDash = false
            self.dashValues.isDashing = true
            self.restoreValuesAfterDash()
        }
    }
    
    private func restoreValuesAfterDash() {
        Timer.scheduledTimer(withTimeInterval: dashValues.duration, repeats: false) { _ in
            if self.directionValues.lastDirection.dy >= 0 { self.physicsBody?.velocity.dx = self.directionValues.lastDirection.normalized().dx * self.directionValues.lastSpeed }
            self.physicsBody?.fieldBitMask = ColliderType.gravity
            self.cooldownDash()
        }
    }
    
    private func cooldownDash() {
        self.dashValues.isDashing = false
        self.dashValues.isCooldownling = true
        Timer.scheduledTimer(withTimeInterval: dashValues.cooldown, repeats: false) { _ in
            self.dashValues.isCooldownling = false
        }
    }
}

// MARK: Stomp action implementation
extension Player {
    func stomp() {
        let impulseVector = CGVector(dx: 0, dy: -700)
        self.physicsBody?.velocity.dy = 0
        self.physicsBody?.applyForce(impulseVector)
        self.run(.playSoundFileNamed("stomp.wav", waitForCompletion: false))
    }
}

// MARK: Shoot action implementation
extension Player {
    func throwSword(rotation: CGFloat, direction: CGPoint){
        //let sword = Sword(texture: SKTexture(imageNamed: "Sword"), color: .white, size: CGSize(width: 10, height: 40), lifeTime: swordLifeTime, scene: self.scene)
        let sword = pool.get()!
        self.scene?.addChild(sword)
        
        sword.throwSword(position: self.position, rotation: rotation, speed: 1000)
        self.run(.playSoundFileNamed("playerAttack.mp3", waitForCompletion: false))
        sword.destroy()
    }
    
    func aim(direction: CGPoint) {
        let angle = (atan2(direction.x, -direction.y))
        gunArm.zRotation =  angle - (90 * CGFloat.degreesToRadians)
        
        flip(toTheRight: angle * CGFloat.radiansToDegrees > 0)
        
        if combatValues.canShoot {
            throwSword(rotation: gunArm.zRotation, direction: direction)
            cooldownShoot()
        }
        
    }
    
    func cooldownShoot() {
        combatValues.canShoot = false
        Timer.scheduledTimer(withTimeInterval: combatValues.shootCoolDown, repeats: false) { _ in
            self.combatValues.canShoot = true
        }
    }
    
    func cancelAim(){
        //changeDirection()
    }
}

// MARK: Combat implementation
extension Player {
    func receiveDamage(percentage: Int) {
        if combatValues.isDead { return }
        combatValues.hp -= percentage
        print("\(combatValues.hp)")
        if combatValues.hp == 0 { die() }
        else { self.run(.playSoundFileNamed("damage.wav", waitForCompletion: true)) }
    }
    
    func die() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.run(.playSoundFileNamed("die.wav", waitForCompletion: true))
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.run(.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
        }
        (scene as? GameScene)?.showMenu()
        combatValues.isDead = true
    }
}

// MARK: Joystick actions implementation
extension Player: Controllable2D {
    func move(for velocity: CGPoint) {
        if directionValues.lastDirection != velocity {
            self.directionValues.lastDirection = CGVector(dx: velocity.x, dy: velocity.y)
        }
        
        if (self.dashValues.willDash)
        || (!self.dashValues.isDashing && !self.wallJumpValues.isWallJumping)
        || (self.wallJumpValues.isWallJumping && self.wallJumpValues.isFallingFromWallJump) {
            self.startWalking(direction: velocity)
        }
    }
    
    func stopMoving() {
        self.physicsBody?.velocity.dx = 0
        self.directionValues.lastDirection.dy = 0
        self.directionValues.lastSpeed = 0
        self.directionValues.isWalking = false
    }
    
    func rotate(for angularVelocity: CGFloat) {
        if (angularVelocity.magnitude < 0) { return }
        //var temp = (angularVelocity.magnitude * -CGFloat(self.directionValues.facedDirection)).rounded(toPlaces: 1)
        
        
        let direction = CGPoint(angle: angularVelocity + 90 * CGFloat.degreesToRadians)
        aim(direction: direction)
    }
    
}
extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: Conforming to Updatable protocol
extension Player: Updatable {
    func update(currentTime: TimeInterval) {}
}

//
//  Sword.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 27/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Sword: SKSpriteNode{
    var swordLifeTime: Double
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, lifeTime: Double = 1, scene: SKScene?) {
        swordLifeTime = lifeTime
        super.init(texture: texture, color: color, size: size)
        self.alpha = 0.5
        
        setupBody()
        
        scene?.addChild(self)
        
    }
    func setupBody(){
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 20))
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = ColliderType.sword
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.wall | ColliderType.platform
        self.physicsBody?.contactTestBitMask = ColliderType.sword | ColliderType.hazard
        self.physicsBody?.mass = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOrientation(position: CGPoint, rotation: CGFloat){
        self.position = position
        self.position.y += 30
        
        self.zRotation = rotation
    }
    
    func throwSword(position: CGPoint, rotation: CGFloat, speed: CGFloat){
        let swordRotation = rotation + 270 * CGFloat.degreesToRadians
        let direction = CGVector(angle: rotation)
        setOrientation(position: position, rotation: swordRotation)
        self.physicsBody?.velocity =  direction * speed
    }
    
    func destroy(){
        Timer.scheduledTimer(withTimeInterval: swordLifeTime, repeats: false, block: {_ in self.removeFromParent()})
    }
    override func copy() -> Any {
        return Sword(texture: self.texture, color: self.color, size: self.size, lifeTime: self.swordLifeTime, scene: self.parent as? SKScene)
    }
    
    static func copy(sword: Sword) -> Sword{
        return Sword(texture: sword.texture, color: sword.color, size: sword.size, lifeTime: sword.swordLifeTime, scene: sword.parent as? SKScene)
    }
}

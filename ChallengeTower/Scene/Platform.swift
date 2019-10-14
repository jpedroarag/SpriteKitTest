//
//  Platform.swift
//  aa
//
//  Created by João Pedro Aragão on 01/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import SpriteKit

class Platform: SKNode { 
    
    var sprite: SKSpriteNode!
    
    init(texture: SKTexture? = nil, size: CGSize = .zero, position: CGPoint = .zero) {
        super.init()
        name = "Platform"
        sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
        sprite.position = position
        setupPhysics(size: size, position: position)
        addChild(sprite)
    }
    
    private func setupPhysics(size: CGSize, position: CGPoint) {
        let physics = SKPhysicsBody(rectangleOf: size, center: position)
        physics.contactTestBitMask = ColliderType.player
        physics.categoryBitMask = ColliderType.platform
        physics.linearDamping = 0
        physics.allowsRotation = false
        physics.affectedByGravity = false
        physics.isDynamic = false
        physicsBody = physics
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

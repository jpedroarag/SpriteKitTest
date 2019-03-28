//
//  Arm.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 26/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Arm: SKSpriteNode{
    
    
    init(){
        super.init(texture: nil, color: .white, size: CGSize(width: 0, height: 0))
        self.position.x = 10
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 5))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.friction = 0
        self.physicsBody?.collisionBitMask = ColliderType.none
        self.physicsBody?.categoryBitMask = ColliderType.none
        self.physicsBody?.contactTestBitMask = ColliderType.none
        self.physicsBody?.allowsRotation = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

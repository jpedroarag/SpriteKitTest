//
//  GameStartNode.swift
//  aa
//
//  Created by João Pedro Aragão on 26/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import SpriteKit

class MenuNode: SKNode {
    
    var startButton: VirtualButton!
    var background: SKSpriteNode!
    
    init(addTo scene: SKScene) {
        super.init()
        
        background = SKSpriteNode(texture: nil, color: .black, size: scene.view!.frame.size)
        background.alpha = 0.9
        addChild(background)
        
        let texture = SKTexture(imageNamed: "Play")
        startButton = VirtualButton(texture: texture, color: .red, size: .from(100), position: .zero)
        startButton.addAction(action: { self.isHidden = true }, type: .began)
        addChild(startButton)
        
        scene.addChild(self)
        zPosition = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

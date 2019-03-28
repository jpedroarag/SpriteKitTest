//
//  GameStartNode.swift
//  aa
//
//  Created by João Pedro Aragão on 26/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import SpriteKit

class MenuNode: SKNode {
    
    var label: SKLabelNode!
    var startButton: VirtualButton!
    var background: SKSpriteNode!
    
    init(addTo scene: SKScene) {
        super.init()
        
        background = SKSpriteNode(texture: nil, color: .white, size: scene.view!.frame.size)
        background.alpha = 0.9
        addChild(background)
        
        let texture = SKTexture(imageNamed: "Start")
        startButton = VirtualButton(texture: texture, color: .red, size: .from(100), position: .zero)
        addChild(startButton)
        
        label = SKLabelNode(text: "Press to start the game")
        label.fontSize = startButton.size.width/2
        label.fontColor = .black
        addChild(label)
        
        startButton.position.y -= startButton.size.height/4 + 8
        label.position.y += startButton.size.height/4 + 8
        
        scene.addChild(self)
        zPosition = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

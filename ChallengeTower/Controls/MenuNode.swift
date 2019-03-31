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
    var sublabel: SKLabelNode!
    var startButton: VirtualButton!
    var background: SKSpriteNode!
    
    init(addTo scene: SKScene) {
        super.init()
        
        background = SKSpriteNode(texture: SKTexture(imageNamed: "menuBackground"), color: .clear, size: scene.view!.frame.size)
        background.position = .zero
        addChild(background)
        background.zPosition = 1
        
        startButton = VirtualButton(texture: nil, color: .black, size: background.size, position: background.position)
        startButton.alpha = 0.5
        addChild(startButton)
        startButton.zPosition = 2
        
        label = SKLabelNode(text: "Press anywhere to start")
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "MonogramExtended"
        label.verticalAlignmentMode = .center
        addChild(label)
        label.zPosition = 3
        
        sublabel = SKLabelNode(fontNamed: "MonogramExtended")
        sublabel.fontSize = 40
        sublabel.text = "Press anywhere to try again"
        sublabel.fontColor = .white
        sublabel.verticalAlignmentMode = .center
        label.addChild(sublabel)
        sublabel.position.y -= label.fontSize
        sublabel.isHidden = true
        
        scene.addChild(self)
        zPosition = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

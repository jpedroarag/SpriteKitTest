//
//  TapRegion.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class VirtualButton: SKSpriteNode {
    
    var touchActions = TouchActions()
    
    init(texture: SKTexture? = nil, color: UIColor, size: CGSize, position: CGPoint = .zero, addTo scene: SKScene) {
        super.init(texture: texture, color: color, size: size)
        self.position = position
        self.isUserInteractionEnabled = true
        scene.addChild(self)
    }
    
    func addAction(action: @escaping ()->(), type: TouchType){
        touchActions.addAction(action: action, type: type)
    }
    
    func addActions(actions: [(()->(), TouchType)]){
        actions.forEach({touchActions.addAction(action: $0.0, type: $0.1)})
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchActions.onTouchBegan.forEach({$0()})
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchActions.onTouchMoved.forEach({$0()})
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchActions.onTouchEnded.forEach({$0()})
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchActions.onTouchCancelled.forEach({$0()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TouchActions {
    
    var onTouchBegan: [()->()]
    var onTouchMoved: [()->()]
    var onTouchEnded: [()->()]
    var onTouchCancelled: [()->()]

    
    
    init(){
        onTouchBegan = [()->()]()
        onTouchMoved = [()->()]()
        onTouchEnded = [()->()]()
        onTouchCancelled = [()->()]()
    }
    
    func addAction(action: @escaping ()->(), type: TouchType){
        switch type {
        case .began:
            self.onTouchBegan.append{
                action()
            }
        case .moved:
            self.onTouchMoved.append{
                action()
            }
        case .ended:
             self.onTouchEnded.append{
                action()
            }
        case .cancelled:
             self.onTouchCancelled.append{
                action()
            }
        }
    }


}

enum TouchType{
    case began
    case moved
    case ended
    case cancelled
    
}

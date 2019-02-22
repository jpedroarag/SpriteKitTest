//
//  InputController.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class InputController {
    var tapWalkLeft: VirtualButton!
    var tapWalkRight: VirtualButton!
    var tapJump: VirtualButton!
    var tapDash: VirtualButton!
    
    init(view: SKView, player: Player, buttonsSize: CGSize = .init(width: 80, height: 80), addTo scene: SKScene) {
        createMovementButtons(view: view, player: player, withSize: buttonsSize, addTo: scene)
    }
    
    func createMovementButtons(view: SKView, player: Player, withSize size: CGSize, addTo: SKScene) {
        if let scene = view.scene {
            let viewSize = -view.frame.size/2
            
            tapWalkLeft = VirtualButton(color: .gray, size: size, addTo: scene)
            tapWalkLeft.addAction(action: { player.startWalking(direction: CGPoint.left) }, type: .began)
            tapWalkLeft.addAction(action: { player.stopWalking() }, type: .ended)
            tapWalkLeft.position = CGPoint(fromSize: viewSize + size)
            tapWalkLeft.alpha = 0.5
            
            tapWalkRight = VirtualButton(color: .gray, size: size, addTo: scene)
            tapWalkRight.addAction(action: { player.startWalking(direction: CGPoint.right) }, type: .began)
            tapWalkRight.addAction(action: { player.stopWalking() }, type: .ended)
            tapWalkRight.position = tapWalkLeft.position
            tapWalkRight.position.x += size.width + 8
            tapWalkRight.alpha = 0.5
            
            tapJump = VirtualButton(color: .gray, size: size, addTo: scene)
            tapJump.addAction(action: { player.jump() }, type: .began)
            tapJump.position = tapWalkLeft.position
            tapJump.position.x += size.width/2 + 4
            tapJump.position.y += size.height + 8
            tapJump.alpha = 0.5
            
            tapDash = VirtualButton(color: .red, size: size, addTo: scene)
            tapDash.addAction(action: { player.dash() }, type: .began)
            tapDash.position = tapWalkLeft.position
            tapDash.position.x = tapWalkLeft.position.x * -1
            tapDash.alpha = 0.5
        }
    }
}

extension CGSize {
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static prefix func -(lhs: CGSize) -> CGSize {
        return CGSize(width: -lhs.width, height: -lhs.height)
    }
}

extension CGPoint {
    init(fromSize size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
}


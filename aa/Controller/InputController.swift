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
    var tapJump: VirtualButton!
    var tapDash: VirtualButton!
    var joystick: Joystick!
    
    init(view: SKView, player: Player, buttonsSize: CGSize = .init(width: 80, height: 80), addTo scene: SKScene) {
        createMovementButtons(view: view, player: player, withSize: buttonsSize, addTo: scene)
    }
    
    func createMovementButtons(view: SKView, player: Player, withSize size: CGSize, addTo: SKScene) {
        if let scene = view.scene {
            let viewSize = -view.frame.size/2
            
            joystick = Joystick()
            joystick.position = CGPoint(fromSize: viewSize + size)
            joystick.attach(moveControllable: player)
            scene.addChild(joystick)
            
            tapJump = VirtualButton(color: .purple, size: size, addTo: scene)
            tapJump.addAction(action: { player.jump() }, type: .began)
            tapJump.position = joystick.position
            tapJump.position.x *= -1
            tapJump.alpha = 0.5
            
            tapDash = VirtualButton(color: .red, size: size, addTo: scene)
            tapDash.addAction(action: { player.dash() }, type: .began)
            tapDash.position = joystick.position
            tapDash.position.x *= -1
            tapDash.position.x -= size.width + 4
            tapDash.alpha = 0.5
            
        }
    }
}

extension CGSize {
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
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


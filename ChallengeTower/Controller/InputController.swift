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

class InputController: Updatable {
    func update(currentTime: TimeInterval) {
        joystick.update(currentTime)
        joystickShoot.update(currentTime)
    }
    
    var tapJump: VirtualButton!
    var tapDash: VirtualButton!
    var joystick: Joystick!
    var joystickShoot: Joystick!
    
    init(view: SKView, player: Player, buttonsSize: CGSize = .init(width: 60, height: 60), addTo scene: SKNode) {
        createMovementButtons(view: view, player: player, withSize: buttonsSize, addTo: scene)
    }
    
    func createMovementButtons(view: SKView, player: Player, withSize size: CGSize, addTo node: SKNode) {
        if let scene = view.scene {
            let viewSize = -view.frame.size/2
            
            joystick = Joystick()
            joystick.position = CGPoint(fromSize: viewSize + size)
            joystick.position.x += 36
            joystick.position.y += 36
            joystick.attach(moveControllable: player)
            joystick.forceTouchAction = { _ in player.dash() }
            node.addChild(joystick)
            
            joystickShoot = Joystick()
            joystickShoot.position = joystick.position
            joystickShoot.position.x *= -1
            joystickShoot.attach(rotateControllable: player)
            joystickShoot.forceTouchAction = { _ in player.jump() }
            node.addChild(joystickShoot)
            
            let texture = SKTexture(imageNamed: "Jump")
//            tapJump = VirtualButton(texture: texture, size: size, addTo: scene)
            tapJump = VirtualButton(texture: texture, size: size)
            tapJump.addAction(action: { player.jump() }, type: .began)
            tapJump.position = joystickShoot.position
            tapJump.position.x -= joystick.dpadSize.width/2 + tapJump.size.width/2 + 16
            tapJump.position.y += tapJump.size.height/2
            tapJump.zPosition = 1
            node.addChild(tapJump)
        
            let dashTex = SKTexture(imageNamed: "Dash")
            tapDash = VirtualButton(texture: dashTex, size: size)
            tapDash.addAction(action: { player.dash() }, type: .began)
            tapDash.position = tapJump.position
            tapDash.position.y -= tapJump.size.height + 16
            tapDash.zPosition = 1
            node.addChild(tapDash)
            
        }
    }
}


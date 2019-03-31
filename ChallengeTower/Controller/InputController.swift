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
    var tapStomp: VirtualButton!
    var tapDash: VirtualButton!
    var joystick: Joystick!
    var joystickShoot: Joystick!
    
    init(view: SKView, player: Player, buttonsSize: CGSize = .init(width: 60, height: 60), addTo scene: SKNode) {
        createMovementButtons(view: view, player: player, withSize: buttonsSize, addTo: scene)
    }
    
    func createMovementButtons(view: SKView, player: Player, withSize size: CGSize, addTo node: SKNode) {
        if let _ = view.scene {
            let viewSize = -view.frame.size/2
            
            joystick = Joystick()
            joystick.restriction = .horizontal
            joystick.positionType = .free
            joystick.position = CGPoint(fromSize: viewSize + size)
            joystick.position.x += 36
            joystick.position.y += 36
            joystick.attach(moveControllable: player)
            joystick.forceTouchAction = { _ in player.dash() }
            node.addChild(joystick)
            
            joystickShoot = Joystick()
            joystickShoot.restriction = .vertical
            joystickShoot.positionType = .free
            joystickShoot.position = joystick.position
            joystickShoot.position.x *= -1
            joystickShoot.attach(rotateControllable: player)
            joystickShoot.forceTouchAction = { _ in player.jump() }
            node.addChild(joystickShoot)
            
            let jumpTexture = SKTexture(imageNamed: "Jump")
//            tapJump = VirtualButton(texture: texture, size: size, addTo: scene)
            tapJump = VirtualButton(texture: jumpTexture, size: size)
            tapJump.addAction(action: { player.jump() }, type: .began)
            tapJump.position = joystickShoot.position
            tapJump.position.x -= joystick.dpadSize.width/2 + tapJump.size.width/2 + 16
            tapJump.position.y += tapJump.size.height/2
            tapJump.zPosition = 1
            tapJump.alpha = 0.7
            node.addChild(tapJump)
            
            let stompTexture = SKTexture(imageNamed: "Stomp")
            tapStomp = VirtualButton(texture: stompTexture, size: size)
            tapStomp.addAction(action: { player.stomp() }, type: .began)
            tapStomp.position = tapJump.position
            tapStomp.position.y -= tapJump.size.height + 16
            tapStomp.zPosition = 1
            tapStomp.alpha = 0.7
            node.addChild(tapStomp)
        
            let dashTexture = SKTexture(imageNamed: "Dash")
            tapDash = VirtualButton(texture: dashTexture, size: size)
            tapDash.addAction(action: { player.dash() }, type: .began)
            tapDash.position = tapStomp.position
            tapDash.position.x -= tapStomp.size.width + 16
            tapDash.xScale *= -1
            tapDash.zPosition = 1
            tapDash.alpha = 0.7
            node.addChild(tapDash)
            
        }
    }
}


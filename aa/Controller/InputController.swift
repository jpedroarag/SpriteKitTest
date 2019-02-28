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
//    var tapDash: VirtualButton!
    var joystick: Joystick!
    var joystickShoot: Joystick!
    
    init(view: SKView, player: Player, buttonsSize: CGSize = .init(width: 60, height: 60), addTo scene: SKScene) {
        createMovementButtons(view: view, player: player, withSize: buttonsSize, addTo: scene)
    }
    
    func createMovementButtons(view: SKView, player: Player, withSize size: CGSize, addTo: SKScene) {
        if let scene = view.scene {
            let viewSize = -view.frame.size/2
            
            joystick = Joystick()
            joystick.position = CGPoint(fromSize: viewSize + size)
            joystick.position.x += 36
            joystick.position.y += 36
            joystick.attach(moveControllable: player)
            joystick.forceTouchAction = { _ in player.dash() }
            scene.addChild(joystick)
            
            joystickShoot = Joystick()
            joystickShoot.position = joystick.position
            joystickShoot.position.x *= -1
            joystickShoot.attach(rotateControllable: player)
            scene.addChild(joystickShoot)
            
            let texture = SKTexture(imageNamed: "Jump")
            tapJump = VirtualButton(texture: texture, size: size, addTo: scene)
            tapJump.addAction(action: { player.jump() }, type: .began)
            tapJump.position = joystickShoot.position
            tapJump.position.x -= joystick.dpadSize.width/2 + tapJump.size.width/2 + 8
            
//            tapDash = VirtualButton(color: .red, size: size/2, addTo: scene)
//            tapDash.addAction(action: { player.dash() }, type: .began)
//            tapDash.position = joystickShoot.position
//            tapDash.position.x -= 0
////            tapDash.position.x -= size.width + 4
//            tapDash.position.y += 60
//            tapDash.alpha = 0.5
            
        }
    }
}


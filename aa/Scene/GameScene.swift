//
//  GameScene.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 19/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var player: Player!
    private var updatables = [Updatable]()
    let physicsDelegate = PhysicsDetection()
    var gravityField: SKFieldNode!
    var inputController: InputController!
    
    
    override func didMove(to view: SKView) {
        
        view.showsPhysics = true
        
        physicsWorld.contactDelegate = physicsDelegate
        addGravity()
        player = Player(addToView: self)
        if let scene = view.scene {
            inputController = InputController(view: view, player: player, addTo: scene)
        }
        updatables.append(inputController)
        // 2
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: 5, y: 5)
        // 4
        createSandbox(view: view)

        updatables.append(player)
        //addChild(player)
        
        
    }
    
    func addGravity() {
        physicsWorld.gravity = .zero
        let vector = vector_float3(0, -1, 0)
        gravityField = SKFieldNode.linearGravityField(withVector: vector)
        gravityField.strength = 9.8
        gravityField.categoryBitMask = ColliderType.gravity
        addChild(gravityField)
    }
    
    
    
    func createSandbox(view: SKView) {
        
        let floor = SKSpriteNode(color: .blue, size: CGSize(width: view.bounds.width, height: 20))
        
        floor.position.y = view.bounds.height/2 * -1
        floor.position.x = 0
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        
        floor.physicsBody?.restitution = 0
        floor.physicsBody?.categoryBitMask = ColliderType.ground
        floor.physicsBody?.contactTestBitMask = ColliderType.player
        floor.name = "Ground"
        
        addChild(floor)
        
        let leftWall = SKSpriteNode(color: .red, size: CGSize(width: 30, height: view.bounds.height))
        
        leftWall.position.x = (view.bounds.width/2 * -1) - leftWall.size.width/2 + 10
        
        leftWall.position.y = 0
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        
        leftWall.physicsBody?.restitution = 0
        leftWall.physicsBody?.categoryBitMask = ColliderType.wall
        leftWall.physicsBody?.contactTestBitMask = ColliderType.player
        
        addChild(leftWall)
        
        let rightWall = SKSpriteNode(color: .red, size: CGSize(width: 30, height: view.bounds.height))
        
        rightWall.position.x = view.bounds.width/2 + rightWall.size.width/2 - 10
        rightWall.position.y = 0
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        
        
        rightWall.physicsBody?.restitution = 0
        rightWall.physicsBody?.categoryBitMask = ColliderType.wall
        rightWall.physicsBody?.contactTestBitMask = ColliderType.player
        
        addChild(rightWall)
        
        let ceiling = SKSpriteNode(color: .blue, size: CGSize(width: view.bounds.width, height: 20))
        
        ceiling.position.y = view.bounds.height/2 + ceiling.size.height/2 - 10
        ceiling.position.x = 0
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.restitution = 0
        
        addChild(ceiling)
        
        
        
        let test1 = SKNode()
        let test2 = SKSpriteNode(color: .black, size: CGSize(width: 20, height: 20))
        test1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        test1.physicsBody?.isDynamic = false
        test1.physicsBody?.collisionBitMask = ColliderType.none
        test1.physicsBody?.contactTestBitMask = ColliderType.none
        test2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        test2.position.x = 5
        addChild(test1)
        addChild(test2)
        
        let joint = SKPhysicsJointPin.joint(withBodyA: (test1.physicsBody)!, bodyB: test2.physicsBody!, anchor: test1.position)
        //joint.shouldEnableLimits = true
        test2.physicsBody?.mass = 0.1
        
        scene?.physicsWorld.add(joint)
    }
    
    override func sceneDidLoad() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //inputController.joystick.update(currentTime)
        updatables.forEach { $0.update(currentTime: currentTime) }
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
            //player.aim(direction: (touches.first?.location(in: player))!)
    
        }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            //player.aim(direction: (touches.first?.location(in: player))!)
    
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
            ///player.cancelAim()
        }
    
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
            //player.cancelAim()
        }
}

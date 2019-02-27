////
////  GameScene.swift
////  Sprite
////
////  Created by Gustavo Portela Chaves on 19/02/19.
////  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
//class GameScene2: SKScene{
//    var walking = false
//    // 1
//    var player: Player!
//    
//
//    var tapWalkLeft: VirtualButton!
//    var tapWalkRight: VirtualButton!
//    var tapJump: VirtualButton!
//    let physicsDelegate = PhysicsDetection()
//    private var updatables = [Updatable]()
//
//    func configureCamera() {
//        let camera = SKCameraNode()
//        camera.setScale(1)
//        camera.position.y = -10
//        self.camera = camera
//        self.addChild(camera)
//    }
//
//    override func didMove(to view: SKView) {
//        // 2
//        self.physicsWorld.contactDelegate = physicsDelegate
//        view.showsPhysics = true
//        configureCamera()
//        player = Player(addToView: self)
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        backgroundColor = SKColor.white
//        // 3
//        player.position = CGPoint(x: 0, y: 5)
//        // 4
//        createFloor(view: view)
//        createTouch(view: view)
//
//
//        let test1 = SKNode()
//        let test2 = SKSpriteNode(color: .black, size: CGSize(width: 20, height: 20))
//        test1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
//        test1.physicsBody?.isDynamic = false
//        test1.physicsBody?.collisionBitMask = ColliderType.none
//        test1.physicsBody?.contactTestBitMask = ColliderType.none
//        test2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
//        test2.position.x = 5
//        addChild(test1)
//        addChild(test2)
//
//        let joint = SKPhysicsJointPin.joint(withBodyA: (test1.physicsBody)!, bodyB: test2.physicsBody!, anchor: test1.position)
//        //joint.shouldEnableLimits = true
//        test2.physicsBody?.mass = 0.1
//
//        scene?.physicsWorld.add(joint)
//
//
//        updatables.append(player)
//
//
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//
//    }
//
//    func createTouch(view: SKView){
//        var sizeOfTap = CGSize(width: view.bounds.width/2, height: view.bounds.width/2)
//        var positionOfTap =  CGPoint(x:view.bounds.width/2, y: 0)
//
//        tapWalkRight = VirtualButton(texture: nil, color: .gray, size: sizeOfTap, position: positionOfTap, addTo: self)
//        tapWalkRight.addAction(action: {self.player.walk(direction: CGPoint.right)}, type: .began)
//
//
//        tapWalkRight.alpha = 0.5
//
//         positionOfTap =  CGPoint(x:view.bounds.width/2 * -1, y: 0)
//
//        tapWalkLeft = VirtualButton(texture: nil, color: .gray, size: sizeOfTap, position: positionOfTap, addTo: self)
//        tapWalkLeft.addAction(action: {self.player.walk(direction: CGPoint.left)}, type: .began)
//
//
//        tapWalkLeft.alpha = 0.5
//
//        positionOfTap =  CGPoint(x:0, y: view.bounds.width/2)
//
//        tapJump = VirtualButton(texture: nil, color: .gray, size: sizeOfTap, position: positionOfTap, addTo: self)
//        tapJump.addAction(action: {self.player.jump()}, type: .ended)
//
//
//        tapJump.alpha = 0.5
//    }
//
//    func createFloor(view: SKView){
//        let floor = SKSpriteNode(color: .blue, size: CGSize(width: view.bounds.width, height: 20))
//
//        floor.position.y = view.bounds.height/4 * -1
//        floor.position.x = 0
//        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
//        floor.physicsBody?.isDynamic = false
//
//        floor.physicsBody?.restitution = 0
//        floor.physicsBody?.categoryBitMask = ColliderType.ground
//        //floor.physicsBody?.collisionBitMask = ColliderType.ground
//        floor.physicsBody?.contactTestBitMask = ColliderType.player
//        floor.name = "Ground"
//
//
//        self.addChild(floor)
//    }
//    override func sceneDidLoad() {
//
//    }
//    override func update(_ currentTime: TimeInterval) {
//        updatables.forEach { $0.update(currentTime: currentTime) }
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        walking = true
//        player.aim(direction: (touches.first?.location(in: player))!)
//
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.aim(direction: (touches.first?.location(in: player))!)
//
//    }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
////        walking = false
//        player.cancelAim()
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////        walking = false
//        player.cancelAim()
//    }
//
//}

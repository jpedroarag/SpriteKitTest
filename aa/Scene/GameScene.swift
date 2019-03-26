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
    var platform: Platform!

    var tilemap: SKTileMapNode!
    var tilemapObject = ProceduralTileMap.init()
    
    var menu: MenuNode!
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view.showsPhysics = true
        physicsWorld.contactDelegate = physicsDelegate
        addGravity()
        
        tilemap = tilemapObject.createTileMap(tileSet: "TileSet", columns: 30, rows: 80, widthTile: 32, heightTile: 32)
        scene?.addChild(tilemap)
        tilemapObject.givTileMapPhysicsBody(tileMap: tilemap, viewNode: scene!)
        
        player = Player(addToView: self)
        setupCamera()
        
        if let _ = view.scene {
            inputController = InputController(view: view, player: player, addTo: self.camera!)
        }
        updatables.append(inputController)
        // 2
        
        backgroundColor = UIColor.clear
        // 3
        player.position = CGPoint(x: 5, y: 5)
        // 4
        let enemy = childNode(withName: "enemy")
        enemy?.position = player.position
        enemy?.position.x += 32
        enemy?.physicsBody?.categoryBitMask = ColliderType.hazard
        enemy?.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.wall | ColliderType.platform
        enemy?.physicsBody?.contactTestBitMask = ColliderType.hazard | ColliderType.player
        
        menu = MenuNode(addTo: self)
        menu.position = player.position
        
        updatables.append(player)
    }
    
    func showMenu() {
        menu.isHidden = false
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
        
        let platformSize = CGSize(width: size.width/3, height: 16)
        let platformPosition = CGPoint(x: test2.position.x + platformSize.width/2 + 48, y: 100)
        platform = Platform(size: platformSize, position: platformPosition)
        addChild(platform)
        
        let pos2 = CGPoint(x: -platformPosition.x, y: -50)
        let plat2 = Platform(size: platformSize, position: pos2)
        addChild(plat2)
        
    }
    
    override func sceneDidLoad() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //inputController.joystick.update(currentTime)
        updatables.forEach { $0.update(currentTime: currentTime) }
        followPlayer(player: player)
        
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

extension GameScene{
    enum TileSetType: String {
        case porta = "porta"
        case espinhos = "espinhos"
        case limite = "limite"
        case plataforma = "plataforma"
        case background = "background"
    }
    func setupCamera(){
        guard let camera = scene?.childNode(withName: "camera") as? SKCameraNode else{
            fatalError("Não deu bom 2")
        }
        camera.scene?.scaleMode = .resizeFill
        self.camera = camera
        cameraConstraints()
        camera.position = CGPoint.zero
        
    }
    func followPlayer(player: SKNode) {
        //scene?.camera?.position = player.position
    }
    
    func cameraConstraints(){
        // Constrain the camera to stay a constant distance of 0 points from the player node.
        let zeroRange = SKRange(constantValue: 0.0)
        let playerConstraint = SKConstraint.distance(zeroRange, to: player)
        let tilemapContentRect = CGRect(x: tilemap.position.x, y: tilemap.position.y, width: tilemap.mapSize.width, height: tilemap.mapSize.height)
        
    
        
        //let horizontalRange = SKRange(lowerLimit: tilemapContentRect.minX, upperLimit: tilemapContentRect.minX)
        
        //let verticalRange = SKRange(lowerLimit: -tilemapContentRect.minY/2, upperLimit: tilemapContentRect.maxY/2)
        let horizontalRange = SKRange(lowerLimit: (tilemap.position.x - tilemap.mapSize.width/2) + view!.bounds.width/2, upperLimit: (tilemap.position.x + tilemap.mapSize.width/2) - (view?.bounds.width)!/2)
        
        let verticalRange = SKRange(lowerLimit: (tilemap.position.y - tilemap.mapSize.height/2) + (view?.bounds.height)!/2, upperLimit: (tilemap.position.y + tilemap.mapSize.height/2) - (view?.bounds.height)!/2)

        let tileHorizontalConstraint = SKConstraint.positionX(horizontalRange)
        
        let tileVerticalConstraint = SKConstraint.positionY(verticalRange)

        camera!.constraints = [playerConstraint, tileHorizontalConstraint, tileVerticalConstraint]
    }
    
}

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
    var enemy: FlyingEnemy!
    private var updatables = [Updatable]()
    let physicsDelegate = PhysicsDetection()
    var gravityField: SKFieldNode!
    var inputController: InputController!
    var platform: Platform!
    var colidion = 0
    var tilemap: SKTileMapNode!
    var tilemapObject = ProceduralTileMap.init()
    var menu: MenuNode!
   
    override func didMove(to view: SKView) {
       initialGame(view: view)

    }
    func initialGame(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print("Primeiro")
        print(view.scene?.children)
        view.showsPhysics = true
        physicsWorld.contactDelegate = physicsDelegate
        addGravity()
        tilemap = tilemapObject.createTileMap(tileSet: "TileSet", columns: 50, rows: 20, widthTile: 32, heightTile: 32)
        scene?.addChild(tilemap)
        
        tilemapObject.givTileMapPhysicsBody(tileMap: tilemap, viewNode: scene!)
        
        player = Player(addToView: self)
        enemy = FlyingEnemy(view: self, target: player)
        print("segundo")
        print(view.scene?.children)
        player.combatValues.isDead = true
        menu = MenuNode(addTo: self)
        menu.position = .zero
        menu.startButton.addAction(action: {
            self.menu.isHidden = true
            self.player.combatValues.resetToInitialState()
        }, type: .began)
        setupCamera()
        
        if view.scene != nil {
            inputController = InputController(view: view, player: player, addTo: self.camera!)
        }
        
        
        player.position = CGPoint(x: 5, y: Int(-tilemap.frame.height/2) + 472)
        // 4
        enemy.position = CGPoint(x: self.size.width - 50, y: 30)
        
        updatables.append(inputController)
        updatables.append(player)
        updatables.append(enemy)
        
        // Toca uma música de background
        SKTAudio.sharedInstance().playBackgroundMusic("soundtrack-test.mp3")
        colidion = 0
        
    }
    
    func showMenu() {
        menu.isHidden = false
        menu.label.text = "Oh, you died... 😞"
        menu.startButton.texture = SKTexture(imageNamed: "Restart")
    }

    func addGravity() {
        physicsWorld.gravity = .zero
        let vector = vector_float3(0, -1, 0)
        gravityField = SKFieldNode.linearGravityField(withVector: vector)
        gravityField.strength = 9.8
        gravityField.categoryBitMask = ColliderType.gravity
        addChild(gravityField)
    }
    
    func resetPhase() {
        if colidion == 0 {
           
            let camera  = scene!.childNode(withName: "camera") as! SKCameraNode
            view?.scene?.removeAllChildren()
            camera.position = CGPoint(x: 160.0, y: -143)
            scene?.addChild(camera)
            view?.ignoresSiblingOrder = false
            initialGame(view: view!)
            colidion = 1
        }
      
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
        menu.constraints = camera!.constraints
    }

}

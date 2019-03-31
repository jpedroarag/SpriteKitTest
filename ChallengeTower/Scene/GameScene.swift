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
    var enemies: [FlyingEnemy] = []
    private var updatables = [Updatable]()
    let physicsDelegate = PhysicsDetection()
    var gravityField: SKFieldNode!
    var inputController: InputController!
    var platform: Platform!
    var colidion = 0
    var tilemap: SKTileMapNode!
    var tilemapObject = ProceduralTileMap.init()
    var menu: MenuNode!
    var cameraNew : SKCameraNode!
    
    override func didMove(to view: SKView) {
        initialGame(view: view)
    }
    
    func initialGame(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print("Primeiro")
//        view.showsPhysics = true
        physicsWorld.contactDelegate = physicsDelegate
        addGravity()
        tilemap = tilemapObject.createTileMap(tileSet: "TileSet", columns: 50, rows: 80, widthTile: 32, heightTile: 32)
        scene?.addChild(tilemap)
        
        tilemapObject.givTileMapPhysicsBody(tileMap: tilemap, viewNode: scene!)
        
        player = Player(addToView: self)
        player.combatValues.isDead = true
        
        menu = MenuNode(addTo: self)
        menu.position = .zero
        menu.startButton.addAction(action: {
            self.menu.isHidden = true
            self.player.combatValues.resetToInitialState()
            let x = -self.tilemap.mapSize.width/2 + self.tilemap.tileSize.width * 3
            let y = -self.tilemap.mapSize.height/2 + self.tilemap.tileSize.height * 1
            self.player.position = CGPoint(x: x, y: y)
//            for i in 0 ... 50 { self.enemies[i].position = CGPoint(x: self.size.width - 120, y: CGFloat((300 * i) + (50 - i))) }
            for i in 0 ... 50 { self.enemies[i].position = CGPoint(x: CGFloat(Int.random(in: 0...10) * -i), y: CGFloat((Int.random(in: 0...40) * i) + (Int.random(in: 50...100) - i * Int.random(in: 0...50)))) }
        }, type: .began)
        
        setupCamera()
        
        if view.scene != nil {
            inputController = InputController(view: view, player: player, addTo: self.camera!)
        }
        
        let x = -self.tilemap.mapSize.width/2 + self.tilemap.tileSize.width * 3
        let y = -self.tilemap.mapSize.height/2 + self.tilemap.tileSize.height * 1
        player.position = CGPoint(x: x, y: y)

        updatables.append(inputController)
        updatables.append(player)
        
        for i in 0 ... 50 {
            enemies.append(FlyingEnemy(view: self, target: player))
            enemies[i].position = CGPoint(x: self.size.width - 120, y: CGFloat((300 * i) + (50 - i)))
            updatables.append(enemies[i])
        }
//        enemy = FlyingEnemy(view: self, target: player)
//        enemy.position = CGPoint(x: self.size.width - 120, y: 30)
//        updatables.append(enemy)

        // Toca uma música de background
        SKTAudio.sharedInstance().playBackgroundMusic("8bit Dungeon Boss.mp3")
        colidion = 0

    }
    
    func showMenu() {
        SKTAudio.sharedInstance().playBackgroundMusic("8bit Dungeon Boss Die.mp3")
        menu.isHidden = false
        menu.label.text = "Oh no! You died... 😞"
        menu.sublabel.isHidden = false
        if menu.startButton.touchActions.onTouchBegan.count < 2 {
            menu.startButton.addAction(action: { SKTAudio.sharedInstance().playBackgroundMusic("8bit Dungeon Boss.mp3") }, type: .began)            
        }
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
            let cameta = scene?.childNode(withName: "camera") as! SKCameraNode
            removeAllChildren()
            removeAllActions()
            removeFromParent()
            print(cameta)
            scene?.addChild(cameta)
            initialGame(view: self.view!)
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

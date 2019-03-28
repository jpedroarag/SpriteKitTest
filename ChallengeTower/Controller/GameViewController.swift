//
//  GameViewController.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 19/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var newScene: SKScene!
    
    func loadScene(view: SKView){
        newScene = SKScene(fileNamed: "GameScene")
        if newScene != nil {
            newScene.scaleMode = .aspectFill
            view.presentScene(newScene)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        //let scene = GameScene()
        loadScene(view: skView)
        
        //scene.scaleMode = .resizeFill
        //skView.presentScene(scene)
    }


    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

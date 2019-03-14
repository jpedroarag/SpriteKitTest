//
//  ProcesuralTileMap.swift
//  TleMapPrototype
//
//  Created by João batista Romão on 12/03/19.
//  Copyright © 2019 João batista Romão. All rights reserved.
//

import Foundation
import GameplayKit

class ProceduralTileMap {
    private var matrixTaleMap: [[Int]] = []
    private let proceduralManipulation = ProceduralMatriz()
   
    
    func createTileMap(tileSet: String, columns: Int, rows: Int, widthTile: Int, heightTile: Int) -> SKTileMapNode {
        self.matrixTaleMap = proceduralManipulation.createMatrix(column: columns, row: rows)
        self.matrixTaleMap = proceduralManipulation.reverseMatriz(matrix: matrixTaleMap, rows: rows)
        let tileset = SKTileSet(named: tileSet)!
        let tileTesteMap = SKTileMapNode(tileSet: tileset, columns: columns, rows: rows, tileSize: CGSize(width: widthTile, height: heightTile))
        tileTesteMap.name = "TileMapBase"
        tileTesteMap.position = CGPoint(x: 20 , y: 452)
        for row in 0..<tileTesteMap.numberOfRows{
            for column in 0..<tileTesteMap.numberOfColumns{
                let texture = matrixTaleMap[row][column]
                tileTesteMap.setTileGroup(tileset.tileGroups[texture], forColumn: column, row: row)
            }
        }
        
        return tileTesteMap
    }
    
  
    func givTileMapPhysicsBody(tileMap: SKTileMapNode, viewNode:SKScene ) {
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        let startingLocation:CGPoint = tileMap.position
        for row in 0..<tileMap.numberOfRows{
            for column in 0..<tileMap.numberOfColumns{
                let tileSet = tileMap.tileDefinition(atColumn: column, row: row)
                let tileArray = tileSet?.textures
                let tileTexture = tileArray![0]
                //print(tileTexture)
                
                let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width / 2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                // print(tileTexture)
                
                
                
                switch tileSet?.name{
                case TileSetType.background.rawValue:
                    
                    break
                case TileSetType.limite.rawValue:
                    
                    let tileNode = SKSpriteNode(texture:tileTexture)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width) + 5, height: (tileTexture.size().height) + 5))
                    tileNode.physicsBody?.linearDamping = 0
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.friction = 0
                    tileNode.physicsBody?.categoryBitMask = ColliderType.ground
                    tileNode.physicsBody?.contactTestBitMask = ColliderType.player
                    viewNode.addChild(tileNode)
                    
                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                    break
                case TileSetType.plataforma.rawValue:
                    let tileNode = Platform(texture: tileTexture,
                                            size: CGSize(width: (tileTexture.size().width),
                                                         height: (tileTexture.size().height)),
                                            position: CGPoint(x: x, y: y))
                    viewNode.addChild(tileNode)
                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                    break
                case TileSetType.espinhos.rawValue:
                    
                    break
                case TileSetType.porta.rawValue:
                    break
                default:
                    break
                }
                
            }
        }
        
        
    }
}

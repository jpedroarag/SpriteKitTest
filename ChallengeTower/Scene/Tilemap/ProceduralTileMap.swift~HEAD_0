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
        let startingLocation: CGPoint = tileMap.position
        
        for row in 0..<tileMap.numberOfRows {
            var platStartIndex: Int? = nil
            var platEndIndex: Int? = nil
            
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
                    
                    // Chão e teto
                    if (row == 0 && column == tileMap.numberOfColumns - 1)
                    || (row == tileMap.numberOfRows - 1 && column == tileMap.numberOfColumns - 1) {
                        let size = CGSize(width: CGFloat(tileMap.numberOfColumns) * tileSize.width, height: tileSize.height)
                        let position = CGPoint(x: x + startingLocation.x - size.width/2 + tileSize.width/2, y: y + startingLocation.y)
                        let tileNode = SKSpriteNode(texture: nil)
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: size)
                        tileNode.physicsBody?.linearDamping = 0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        if row == 0 {
                            tileNode.physicsBody?.categoryBitMask = ColliderType.ground
                        }
                        tileNode.physicsBody?.contactTestBitMask = ColliderType.player
                        viewNode.addChild(tileNode)
                        tileNode.position = position
                    }
                    
                    // Paredes
                    if (row == tileMap.numberOfRows - 1 && column == 0)
                    || (row == tileMap.numberOfRows - 1 && column == tileMap.numberOfColumns - 1) {
                        let size = CGSize(width: tileSize.width, height: CGFloat(tileMap.numberOfRows) * tileSize.height)
                        let position = CGPoint(x: x + startingLocation.x, y: y + startingLocation.y - size.height/2 + tileSize.height/2)
                        let tileNode = SKSpriteNode(texture: nil)
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: size)
                        tileNode.physicsBody?.linearDamping = 0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 0
                        tileNode.physicsBody?.restitution = 0
                        tileNode.physicsBody?.categoryBitMask = ColliderType.wall
                        tileNode.physicsBody?.contactTestBitMask = ColliderType.player
                        viewNode.addChild(tileNode)
                        tileNode.position = position
                    }
                    
                case TileSetType.plataforma.rawValue:
                    if platStartIndex == nil {
                        platStartIndex = column
                    }
                    
                    let platEndCondition1 = (tileMap.numberOfColumns - 2 > column + 1 && tileMap.tileDefinition(atColumn: column + 1, row: row)?.name != TileSetType.plataforma.rawValue)
                    let platEndCondition2 = (tileMap.numberOfColumns - 2 == column)
                    if platEndIndex == nil && platStartIndex != nil && (platEndCondition1 || platEndCondition2) {
                        platEndIndex = column
                        
                        let platTilesCount = CGFloat(platEndIndex! - platStartIndex! + 1)
                        let size = CGSize(width: platTilesCount * tileSize.width, height: tileSize.height)
                        let position = CGPoint(x: x + startingLocation.x - size.width/2 + tileSize.width/2, y: y + startingLocation.y)
                        let tileNode = Platform(size: size, position: position)
                        viewNode.addChild(tileNode)
                        
                        platStartIndex = nil
                        platEndIndex = nil
                    }
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

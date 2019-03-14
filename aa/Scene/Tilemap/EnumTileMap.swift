//
//  EnumTileMap.swift
//  TleMapPrototype
//
//  Created by João batista Romão on 12/03/19.
//  Copyright © 2019 João batista Romão. All rights reserved.
//

import Foundation
enum TileSetType: String {
    case porta = "porta"
    case espinhos = "espinhos"
    case limite = "limite"
    case plataforma = "plataforma"
    case background = "background"
}
enum TypeTile: Int {
    case backgorund = 0
    case bounds =     1
    case plataforms = 2
    case enemies =    3
    case exit =       4
    
}


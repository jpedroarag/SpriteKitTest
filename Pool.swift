//
//  Pool.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 27/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation
import SpriteKit

class Pool<T> where T: SKNode {
    var objsPool = [T]()
    var type: T
    var canGrow = false
    
    init(instanceType: T, poolSize: Int, canGrow: Bool = false) {
        self.type = instanceType
        self.canGrow = canGrow
        
        (0..<poolSize).forEach { _ in
            objsPool.append((type.copy() as! T))
        }
    }
    
    func get()->T?{
        var obj: T?
        for obj in objsPool{
            if(obj.parent == nil){
                return obj
            }
        }
        if(canGrow){
            obj = (type.copy() as! T)
            objsPool.append(obj!)
        }
        
        return obj
    }

}

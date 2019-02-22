//
//  Updatable.swift
//  Sprite
//
//  Created by Gustavo Portela Chaves on 20/02/19.
//  Copyright © 2019 Gustavo Portela Chaves. All rights reserved.
//

import Foundation

protocol Updatable: class {
    func update(currentTime: TimeInterval)
}

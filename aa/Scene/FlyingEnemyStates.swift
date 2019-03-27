//
//  FlyingEnemyStates.swift
//  aa
//
//  Created by Matheus Costa on 26/03/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import SpriteKit
import GameplayKit

class IdleState: GKState {
    var enemy: FlyingEnemy

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode
    }

    override func didEnter(from previousState: GKState?) {
        // trocar para animacao parado
    }
}

class HuntingState: GKState {
    var enemy: FlyingEnemy

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode
    }

    override func didEnter(from previousState: GKState?) {
        // trocar para animacao cacando
    }
}

class AtackingState: GKState {
    var enemy: FlyingEnemy

    init(enemyNode: FlyingEnemy) {
        self.enemy = enemyNode
    }

    override func didEnter(from previousState: GKState?) {
        // trocar para animacao atacando
    }
}

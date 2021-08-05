//
//  GoldCoin.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/7/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class GoldCoin: SKSpriteNode {
    
    var goldCoinFrames: [SKTexture] = []
    
    var coinValue = 5
    
    init() {
        super.init(texture: SKTexture(imageNamed: "gold_coin00"), color: UIColor.white, size: CGSize(width: 32, height: 32))
        
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        let coinFrame00 = self.texture!
        let coinFrame01 = SKTexture(imageNamed: "gold_coin01")
        let coinFrame02 = SKTexture(imageNamed: "gold_coin02")
        let coinFrame03 = SKTexture(imageNamed: "gold_coin03")
        let coinFrame04 = SKTexture(imageNamed: "gold_coin04")
        let coinFrame05 = SKTexture(imageNamed: "gold_coin05")
        let coinFrame06 = SKTexture(imageNamed: "gold_coin06")
        let coinFrame07 = SKTexture(imageNamed: "gold_coin07")
        let coinFrame08 = SKTexture(imageNamed: "gold_coin08")
        let coinFrame09 = SKTexture(imageNamed: "gold_coin09")
        let coinFrame10 = SKTexture(imageNamed: "gold_coin10")
        let coinFrame11 = SKTexture(imageNamed: "gold_coin11")
        let coinFrame12 = SKTexture(imageNamed: "gold_coin12")
        let coinFrame13 = SKTexture(imageNamed: "gold_coin13")
        goldCoinFrames.append(contentsOf: [coinFrame00, coinFrame01, coinFrame02, coinFrame03, coinFrame04, coinFrame05, coinFrame06, coinFrame07, coinFrame08, coinFrame09, coinFrame10, coinFrame11, coinFrame12, coinFrame13])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("aDecoder is not used")
    }
    
    func animateCoin() {
        self.run(
            SKAction.repeatForever(
                SKAction.animate(with: self.goldCoinFrames, timePerFrame: 0.08)
            )
        )
    }
    
}

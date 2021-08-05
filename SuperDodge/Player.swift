//
//  Player.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/6/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

protocol PlayerDelegate: class {
    func playerLostHitPoint(currentHitPoint: Int)
}

class Player: SKSpriteNode {
    
    var hitPoint: Int = 300 {
        didSet {
            self.delegate?.playerLostHitPoint(currentHitPoint: hitPoint)
        }
    }
    
    var isHit: Bool = false
    var isSelected: Bool = false
    
    var walkingFrames: [SKTexture] = []
    
    var delegate: PlayerDelegate?
    
    init(size: CGSize, imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.white, size: size)
        //add physicsBody
        self.zPosition = 10
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster + PhysicsCategory.MonsterBullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Decoder not used here
    }
    
    func walk() {
        
        let notMoving = SKTexture(imageNamed: "player_back")
        let rightStep = SKTexture(imageNamed: "player_backRightStep")
        let leftStep = SKTexture(imageNamed: "player_backLeftStep")
        
        walkingFrames.append(contentsOf: [rightStep, leftStep])
        
        self.run(
            SKAction.repeatForever(
                SKAction.animate(with: walkingFrames, timePerFrame: 0.2)
            )
        )
        
    }
    
    
    //
    func startShootingWithBasicWeapon() {
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run {
                        let bullet = Bullet(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
                        bullet.position = self.position
                        bullet.zPosition = 5
                        self.parent?.addChild(bullet)
                        bullet.fireUp()
                    },
                    SKAction.wait(forDuration: 0.05)
                ])
            )
            
        )
    }
    
    func damagedByBullet() {
        
        if self.isHit == false {
            self.isHit = true
            self.hitPoint -= 1
            let fadeOutPlayer = SKAction.fadeOut(withDuration: 0.1)
            let fadeInPlayer = SKAction.fadeIn(withDuration: 0.1)
            let actionDone = SKAction.run{self.isHit = false}
            self.run(SKAction.sequence([fadeOutPlayer, fadeInPlayer, fadeOutPlayer, fadeInPlayer, fadeOutPlayer, fadeInPlayer, fadeOutPlayer, fadeInPlayer, fadeOutPlayer, fadeInPlayer, actionDone]))
        }
        
    }
    
}

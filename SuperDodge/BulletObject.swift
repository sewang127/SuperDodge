//
//  Bullet.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/5/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class BulletObject: SKSpriteNode {
    
    var endPosition: CGPoint?
    
    var bulletSpeed: Double = 2
    
    var direction: CGPoint?
    
    init(size: CGSize, imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.blue, size: size)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterBullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Decoder not used here
    }
    
    fileprivate init(size: CGSize, texture: SKTexture) {
        super.init(texture: texture, color: UIColor.blue, size: size)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterBullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func copy() -> Any {
        let bulletObject = BulletObject(size: self.size, texture: self.texture!)
        return bulletObject
    }
}

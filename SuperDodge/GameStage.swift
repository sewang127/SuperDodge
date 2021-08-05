//
//  Stage.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/7/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class GameStage: SKScene {
    
    var viewHeight: CGFloat!
    var viewWidth: CGFloat!
    
    override func didMove(to view: SKView) {
        self.viewHeight = self.view!.frame.height
        self.viewWidth = self.view!.frame.width
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    func makeGoldCoinAppearRandom() {
        
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run {
                        //Create gold coin
                        let goldCoin = GoldCoin()
                        self.addChild(goldCoin)
                        
                        let randXOffset = CGFloat(drand48()) * (self.viewWidth - 40)
                        
                        let randYOffset = CGFloat(drand48()) * (self.viewHeight - 40)
                        
                        let randomX: CGFloat = randXOffset - (self.viewWidth/2) + 20
                        let randomY: CGFloat = randYOffset - (self.viewHeight/2) + 20
                        
                        goldCoin.position = CGPoint(x: randomX, y: randomY)
                        goldCoin.animateCoin()
                    },
                    SKAction.wait(forDuration: 0.1)
                ])
            )
        )
        
    }
    
    
    //Physics Contact Delegate functions
    func monsterDidCollideWithPlayer(monster: SKSpriteNode, player: SKSpriteNode) {
        //Will be overriden
    }
    
    func monsterDidCollideWithBullet(monster: SKSpriteNode, bullet: SKSpriteNode) {
        //Will be overriden
    }
    
    func playerDidCollideWithBullet(player: SKSpriteNode, bullet: SKSpriteNode) {
        //Will be overriden
    }
    
    func playerDidCollideWithCoin(player: SKSpriteNode, coin: GoldCoin) {
        //Will be overriden
    }

    
}

extension GameStage: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var first: SKPhysicsBody!
        var second: SKPhysicsBody!
        
        //order the bodies by the number
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        } else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        //Monster and Player
        if (first.categoryBitMask == PhysicsCategory.Monster && second.categoryBitMask == PhysicsCategory.Player) {
            self.monsterDidCollideWithPlayer(monster: first.node as! SKSpriteNode, player: second.node as! SKSpriteNode)
        }
        
        //Monster and Bullet
        if (first.categoryBitMask == PhysicsCategory.Monster && second.categoryBitMask == PhysicsCategory.Bullet) {
            if let monster = first.node as? Monster, let bullet = second.node as? Bullet {
                self.monsterDidCollideWithBullet(monster: monster, bullet: bullet)
            }
            
        }
        
        //MonsterBullet and Player
        if (first.categoryBitMask == PhysicsCategory.Player && second.categoryBitMask == PhysicsCategory.MonsterBullet) {
            if let player = first.node as? Player, let bullet = second.node as? BulletObject {
                self.playerDidCollideWithBullet(player: player, bullet: bullet)
            }
        }
        
        //player and Coin
        if (first.categoryBitMask == PhysicsCategory.Player && second.categoryBitMask == PhysicsCategory.Coin) {
            //remove bullet
            if let player = first.node as? Player, let coin = second.node as? GoldCoin {
                self.playerDidCollideWithCoin(player: player, coin: coin)
            }
        }
        
    }
}

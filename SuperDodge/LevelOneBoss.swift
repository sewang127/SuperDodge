//
//  LevelOneBoss
//  SuperDodge
//
//  Created by Se Wang Oh on 11/5/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class LevelOneBoss: Monster {
    
    weak var player: Player!
    
    var isAttacking = false
    
    //8 homing Missile
    func shootHomingMissile() {
        
        //Actions: deploy missile around the boss, target the main character, shoot!
        
        var bulletArray: [BulletObject] = []
        
        //Deploy bullets
        let deployAction = SKAction.run {
            
            //Create Bullet
            for _ in 0..<8 {
                let bullet = BulletObject(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
                bulletArray.append(bullet)
            }
            
            let bulletPosY = self.position.y - self.size.height
            
            let bulletOffsetX = ((bulletArray.first?.size.width ?? 40) + 10) * CGFloat(bulletArray.count/2)
            
            let bulletPosX = self.position.x - bulletOffsetX
            
            for index in 0..<bulletArray.count {
                
                let eachBullet = bulletArray[index]
                
                let newBulletPosX = bulletPosX + ((eachBullet.size.width + CGFloat(10)) * CGFloat(index))
                
                eachBullet.position = self.position
                eachBullet.endPosition = CGPoint(x: newBulletPosX, y: bulletPosY)
                
                self.parent?.addChild(eachBullet)
                
                //run the action
                eachBullet.run(SKAction.move(to: eachBullet.endPosition!, duration: 4))
                
            }
            
        }
        
        //Targeting Action
        let targetAction = SKAction.run {
            
            bulletArray.forEach({ eachBullet in
                
                //Make some randome offset upto main char size * 3
                let mainCharSizeOffsetX = self.player.size.width * 3
                //let mainCharSizeOffsetY = self.mainChar.size.height * 3
                
                let randomOffsetX = (CGFloat(drand48()) * mainCharSizeOffsetX) - mainCharSizeOffsetX/2
                
                let targetPosition = CGPoint(x: self.player.position.x, y: self.player.position.y)
                
                //get direction from target
                let direction = targetPosition - eachBullet.position
                
                
                //Give it 15% offset
                let directionWithOffset = CGPoint(x: direction.x + randomOffsetX, y: direction.y)

                let normalizeDirection = directionWithOffset.normalized()
                
                eachBullet.endPosition = normalizeDirection * 2000
            })
            
        }
        
        //Shoot Action
        let shootAction = SKAction.run {
            bulletArray.forEach({ eachBullet in
                
                let bulletMovement = SKAction.move(to: eachBullet.endPosition!, duration: eachBullet.bulletSpeed)
                let bulletRemove = SKAction.removeFromParent()
                
                eachBullet.run(SKAction.sequence([bulletMovement, bulletRemove]))
                bulletArray.removeAll()
            })
        }
        
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    deployAction,
                    SKAction.wait(forDuration: 2),
                    targetAction,
                    shootAction,
                    SKAction.wait(forDuration: 0.2)
                    ]))
        )
        
    }
    
    //Shoot machine guns
    func shootMachineGun() {
        
        //Actions: target the main character, shoot with mass bullets!
        
        var bullet: BulletObject!
        
        //Targeting Action
        let targetAction = SKAction.run {
            
            bullet = BulletObject(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
            bullet.position = self.position
            self.parent?.addChild(bullet)
            
            let targetPosition = CGPoint(x: self.player.position.x, y: self.player.position.y)
            
            //get direction from target
            let direction = targetPosition - bullet.position
            
            let normalizeDirection = direction.normalized()
            
            bullet.endPosition = normalizeDirection * 2000
        }
        
        //Shoot Action
        let shootAction = SKAction.run {
            
            let bulletMovement = SKAction.move(to: bullet.endPosition!, duration: bullet.bulletSpeed * 4)
            let bulletRemove = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([bulletMovement, bulletRemove]))
            
        }
        
        let ActionDone = SKAction.run {
            self.isAttacking = false
        }
        
        self.run(
            SKAction.sequence([
                SKAction.repeat(
                    SKAction.sequence([
                        targetAction,
                        shootAction,
                        SKAction.wait(forDuration: 0.05)
                        ])
                    , count: 200),
                ActionDone
            ])
        )
    }
    
    //shoot random bullets
    func shootRandomBullets() {
        
        //Actions: randomly shoot, shoot with mass bullets!
        
        var bullet: BulletObject!
        
        //Targeting Action
        let targetAction = SKAction.run {
            
            bullet = BulletObject(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
            bullet.position = self.position
            self.parent?.addChild(bullet)
            
            //randomly select direction
            let directionX = drand48() * 4 - 2
            let directionY = -1.0
            
            let direction = CGPoint(x: directionX, y: directionY)
            
            let normalizeDirection = direction.normalized()
            
            bullet.endPosition = normalizeDirection * 2000
        }
        
        //Shoot Action
        let shootAction = SKAction.run {
            
            let bulletMovement = SKAction.move(to: bullet.endPosition!, duration: bullet.bulletSpeed * 10)
            let bulletRemove = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([bulletMovement, bulletRemove]))
            
        }
        
        let ActionDone = SKAction.run {
            self.isAttacking = false
        }
        
        self.run(
            SKAction.sequence([
                SKAction.repeat(
                    SKAction.sequence([
                        targetAction,
                        shootAction,
                        SKAction.wait(forDuration: 0.1)
                        ])
                    , count: 200),
                ActionDone
                ])
        )
    }
    
    
}

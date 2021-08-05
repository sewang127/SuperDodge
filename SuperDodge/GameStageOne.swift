//
//  StageOne.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/6/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class GameStageOne: GameStage {
    
    var boss: LevelOneBoss!
    var player: Player!
    
    weak var playerHPText: UILabel?
    weak var bossHPLabel: UILabel?
    weak var bossHPView: UIView?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let playerHPlabel = UILabel(frame: CGRect(x: 10, y: (self.view?.frame.height)! - 50, width: 200, height: 50))
        self.playerHPText = playerHPlabel
        self.view?.addSubview(playerHPText!)
        
        //Boss HP
        let bossHPText = UILabel(frame: CGRect(x: self.view!.frame.width - 200, y: (self.view?.frame.height)! - 50, width: 200, height: 50))
        self.bossHPLabel = bossHPText
        self.view?.addSubview(bossHPText)
        
        let hpGuage = UIView(frame: CGRect(x: self.view!.frame.width - 200, y: (self.view?.frame.height)! - 150, width: 200, height: 50))
        hpGuage.backgroundColor = UIColor.red
        hpGuage.layer.borderColor = UIColor.black.cgColor
        hpGuage.layer.borderWidth = 2
        self.bossHPView = hpGuage
        self.view?.addSubview(hpGuage)
        
        //Initializer for scene
        self.setupStage()
        playerHPText?.text = "Player HP: \(self.player.hitPoint)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touchLocation = touches.first?.location(in: self)
            if let player = self.atPoint(touchLocation!) as? Player {
                print("Player clicked")
                self.player.isSelected = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            if let touchLocation = touches.first?.location(in: self) {
                if self.player.isSelected {
                    self.player.position = touchLocation
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player.isSelected = false
    }
    
    func setupStage() {
        
        //loop the map
        let screenHeight = self.view?.frame.height ?? 0
        
        let stageMap = self.childNode(withName: "StageOneMap")!
        
        stageMap.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: -screenHeight/2, duration: 3),
                    SKAction.run {
                        stageMap.position.y = 0
                    }
                ])
            )
        )
        
        //make player
        let player = Player(size: CGSize(width: 50, height: 50), imageNamed: "player_back")
        self.player = player
        self.player.delegate = self
        player.position.y = -(screenHeight/2) + player.size.height
        self.addChild(player)
        player.walk()
        player.startShootingWithBasicWeapon()
        
        //make boss
        // ADD lvl 1 boss
        let lvlOneBoss = LevelOneBoss(size: CGSize(width: 300, height: 300), imageNamed: "playerFace")
        self.boss = lvlOneBoss
        self.boss.delegate = self
        lvlOneBoss.position = CGPoint(x: 0, y: screenHeight/2 - 150)
        lvlOneBoss.player = player
        self.addChild(lvlOneBoss)
        lvlOneBoss.shootHomingMissile()
        changeBossPattern()
        
        //Gold appear
        super.makeGoldCoinAppearRandom()
    }
    
    
    ///Physics Delegate Func
    override func monsterDidCollideWithPlayer(monster: SKSpriteNode, player: SKSpriteNode) {
        print("Monster collide")
    }
    
    override func monsterDidCollideWithBullet(monster: SKSpriteNode, bullet: SKSpriteNode) {
        self.boss.damagedByBullet()
        bullet.removeFromParent()
    }
    
    override func playerDidCollideWithBullet(player: SKSpriteNode, bullet: SKSpriteNode) {
        self.player.damagedByBullet()
    }
    
    override func playerDidCollideWithCoin(player: SKSpriteNode, coin: GoldCoin) {
        print("Player Coin: \(PlayerData.sharedInstance.playerCoin)")
        PlayerData.sharedInstance.playerCoin += coin.coinValue
        coin.removeFromParent()
    }
    
    func showGameOverScene() {
        let gameOverScene = SKScene(fileNamed: "GameOverScene")
        gameOverScene?.scaleMode = .resizeFill
        gameOverScene?.backgroundColor = UIColor.black
        self.view?.presentScene(gameOverScene)
    }
    
    func showGameWonScene() {
        let gameWonScene = SKScene(fileNamed: "GameWonScene")
        gameWonScene?.scaleMode = .resizeFill
        gameWonScene?.backgroundColor = UIColor.black
        self.view?.presentScene(gameWonScene)
    }
    
    //Boss Patern
    func changeBossPattern() {
        //Change Boss Patern every 5 sec
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.wait(forDuration: 5),
                    SKAction.run {
                        if self.boss.isAttacking == false {
                            self.boss.isAttacking = true
                            
                            let randNum = (drand48() * 2)
                            let patternNum = Int(randNum)
                            print("randValue: \(randNum)")
                            print("pattern num: \(patternNum)")
                            
                            switch patternNum {
                            case 0:
                                self.boss.shootMachineGun()
                            case 1:
                                self.boss.shootRandomBullets()
                            default:
                                print("not handled pattern")
                            }
                        }
                    }
                ])
            )
        )
    }
}

extension GameStageOne: PlayerDelegate {
    func playerLostHitPoint(currentHitPoint: Int) {
        self.playerHPText?.text = "Player HP: \(currentHitPoint)"
        
        if currentHitPoint == 0 {
            self.showGameOverScene()
        }
    }
}

extension GameStageOne: MonsterDelegate {
    func monsterGotHit(hpLeft: Int, hpFull: Int) {
        self.bossHPLabel?.text = "Boss HP: \(hpLeft)"
        
        //Change HP guage bar
        let fullGuage = 200
        let fullHP = hpFull
        
        let currentHPRatio = Double(hpLeft)/Double(fullHP)
        
        let currentGuage = Double(fullGuage) * currentHPRatio
        
        self.bossHPView?.frame.size.width = CGFloat(currentGuage)
        
        if hpLeft < 0 {
            self.showGameWonScene()
        }
    }
}

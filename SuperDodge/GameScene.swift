//
//  GameScene.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/2/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Monster: UInt32 = 0b1
    static let Player: UInt32 = 0b10
    static let Bullet: UInt32 = 0b100
    static let MonsterBullet: UInt32 = 0b1000
    static let Coin: UInt32 = 0b10000
}

class Bullet: SKSpriteNode {
    
    init(size: CGSize, imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.blue, size: size)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
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
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func copy() -> Any {
        let bulletObject = Bullet(size: self.size, texture: self.texture!)
        return bulletObject
    }
    
    func fireUp() {
        
        let x = self.position.x
        let y = self.position.y + 1200
        let endPoint = CGPoint(x: x, y: y)
        let movement = SKAction.move(to: endPoint, duration: TimeInterval(exactly: 1)!)
        let movementDone = SKAction.removeFromParent()
        
        self.run(SKAction.sequence([movement, movementDone]))
    }
    
}

class MonsterBullet: Bullet {
    
    override init(size: CGSize, imageNamed: String) {
        super.init(size: size, imageNamed: imageNamed)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterBullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override init(size: CGSize, texture: SKTexture) {
        super.init(size: size, texture: texture)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.MonsterBullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func copy() -> Any {
        let bulletObject = MonsterBullet(size: self.size, texture: self.texture!)
        return bulletObject
    }
    
}

protocol MonsterDelegate: class {
    func monsterGotHit(hpLeft: Int, hpFull: Int)
}

class Monster: SKSpriteNode {
    
    var hitPoint: Int = 3000
    
    var isHit: Bool = false
    
    weak var delegate: MonsterDelegate?
    
    init(size: CGSize, imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.white, size: size)
        //add physicsBody
        self.zPosition = 9
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player + PhysicsCategory.Bullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Decoder not used here
    }
    
    func move(to: CGPoint) {
        
        let movement = SKAction.move(to: to, duration: TimeInterval(exactly: 1)!)
        
        self.run(movement)
    }
    
    func moveRandom() {
        
        let x = random(min: -20.0, max: 20.0)
        let y = random(min: -20.0, max: 20.0)
        
        var newPosition = self.position
        
        newPosition.x += CGFloat(x)
        newPosition.y += CGFloat(y)
        
        let movement = SKAction.move(to: newPosition, duration: TimeInterval(exactly: 1)!)
        
        self.run(movement)
        
    }
    
    func damagedByBullet() {
        
        self.hitPoint -= 5
        self.delegate?.monsterGotHit(hpLeft: self.hitPoint, hpFull: 3000)
        
        if self.isHit == false {
            self.isHit = true
            let changeColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.8, duration: 0.05)
            let revertColor = SKAction.colorize(withColorBlendFactor: 0, duration: 0.05)
            let actionDone = SKAction.run{self.isHit = false}
            self.run(SKAction.sequence([changeColor, revertColor, actionDone]))
        }
        
    }
    
    func random() -> Double {
        return drand48()
    }
    
    func random(min: Double, max: Double) -> Double {
        return self.random() * (max - min) + min
    }
    
    //Monster Bullet
    func homingShot(bullet: MonsterBullet, to: CGPoint) {
        
        //homing shot
        let offset = to - self.position
        let direction = offset.normalized()
        let shootAmount = direction * 2000
        
        let realDest = shootAmount + to
        
        
        let bulletCopy = bullet.copy() as! MonsterBullet
        bulletCopy.position = self.position
        self.parent?.addChild(bulletCopy)
        let bulletMovement = SKAction.move(to: realDest, duration: 1)
        let bulletRemove = SKAction.removeFromParent()
        bulletCopy.run(SKAction.sequence([bulletMovement, bulletRemove]))
    }
    
}

protocol AirShipDelegate: class {
    func airShipMoved()
}

class AirShip: SKSpriteNode {
    
    weak var delegate: AirShipDelegate?
    
    //override the property
    override var position: CGPoint {
        didSet {
            self.delegate?.airShipMoved()
        }
    }
    
    init(size: CGSize, imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.white, size: size)
        //add physicsBody
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Decoder not used here
    }
    
    func allAroundShot(bullet: Bullet) {
        
        
        //need 8 bullets
        let upPoint = CGPoint(x: self.position.x, y: self.position.y + 1)
        let upRightPoint = CGPoint(x: self.position.x + 1, y: self.position.y + 1)
        let upLeftPoint = CGPoint(x: self.position.x - 1, y: self.position.y + 1)
        let rightPoint = CGPoint(x: self.position.x + 1, y: self.position.y)
        let leftPoint = CGPoint(x: self.position.x - 1, y: self.position.y)
        let downPoint = CGPoint(x: self.position.x, y: self.position.y - 1)
        let downRightPoint = CGPoint(x: self.position.x + 1, y: self.position.y - 1)
        let downLeftPoint = CGPoint(x: self.position.x - 1, y: self.position.y - 1)
        
        let bulletArrays: [CGPoint] = [upPoint, upRightPoint, upLeftPoint, rightPoint, leftPoint, downPoint, downRightPoint, downLeftPoint]
        
        bulletArrays.forEach({ eachBullet in
        
            let offset = eachBullet - self.position
            let direction = offset.normalized()
            let shootAmount = direction * 2000
            
            let realDest = shootAmount + self.position
            
            let bulletMovement = SKAction.move(to: realDest, duration: 2)
            let bulletRemove = SKAction.removeFromParent()
            print("All around")
            let bulletCopy = (bullet.copy() as! SKSpriteNode)
            bulletCopy.position = self.position
            self.parent?.addChild(bulletCopy)
            bulletCopy.run(SKAction.sequence([bulletMovement, bulletRemove]))
        })
    }
    
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var monsters: [Monster] = []
    
    var maxMonsters = 10
    
    var mainCharacter: AirShip?
    
    var backgroundNode: SKTileMapNode!
    
    weak var hpLabel: UILabel?
    
    weak var hpGuage: UIView?
    
    override func didMove(to view: SKView) {
        
        self.backgroundNode = self.childNode(withName: "mainBackgroundNode") as! SKTileMapNode
        
        
        
        //Set Physics
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        
        let bossHPText = UILabel(frame: CGRect(x: 10, y: (self.view?.frame.height)! - 50, width: 200, height: 50))
        self.hpLabel = bossHPText
        self.view?.addSubview(bossHPText)
        
        let hpGuage = UIView(frame: CGRect(x: 10, y: (self.view?.frame.height)! - 150, width: 200, height: 50))
        hpGuage.backgroundColor = UIColor.red
        hpGuage.layer.borderColor = UIColor.black.cgColor
        hpGuage.layer.borderWidth = 2
        self.hpGuage = hpGuage
        self.view?.addSubview(hpGuage)
        
        /*
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
        let node = AirShip(size: CGSize(width: 100, height: 100), imageNamed: "Spaceship")
        node.position = CGPoint(x: 200, y: 200)
        self.addChild(node)
        self.mainCharacter = node
        self.mainCharacter?.zPosition = 10
        self.mainCharacter?.delegate = self
        
        //Keep adding monster
        self.run(SKAction.repeatForever(
            SKAction.sequence(
                [
                SKAction.run {
                    
                    if self.monsters.count < self.maxMonsters {
                        let monsterA = Monster(size: CGSize(width: 100, height: 100), imageNamed: "Monster")
                        monsterA.position = self.randomCoordinates()
                        self.monsters.append(monsterA)
                        self.addChild(monsterA)
                    }
                    
                },
                SKAction.run {
                    self.monsters.forEach{$0.moveRandom()}
                    },
                SKAction.wait(forDuration: 0.1)
                ]
            )
        ))
        
        //Fire bullets
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run {
                        let bullet = Bullet(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
                        bullet.position = (self.mainCharacter?.position)!
                        self.addChild(bullet)
                        bullet.fireUp()
                    },
                    SKAction.wait(forDuration: 0.05)
                ])
            )
        
        )
 /*
        //All around shot
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run {
                        let bullet = Bullet(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
                        self.mainCharacter?.allAroundShot(bullet: bullet)
                    },
                    SKAction.wait(forDuration: 1)
                    ])
            )
            
        )
   */
        let topLeftPos = self.view!.convert(self.view!.frame.origin, to: self)
        var boss: Monster!
        //Boss monster appears
        self.run(
            SKAction.run {
                boss = Monster(size: CGSize(width: 400, height: 400), imageNamed: "Monster")
                boss.position = (self.mainCharacter?.position)!
                boss.hitPoint = 3000
                boss.delegate = self
                self.hpLabel?.text = "Boss HP: \(boss.hitPoint)"
                self.addChild(boss)
                
            }
        )
        
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([SKAction.run {
                    let bullet = MonsterBullet(size: CGSize(width: 40, height: 40), imageNamed: "Bullet")
                    boss.homingShot(bullet: bullet, to: topLeftPos)
                    }, SKAction.wait(forDuration: 1)
                                   
                                   
                ])
                
            )
        )
        let screenHeight = self.view?.frame.height
        
        let reloadMapAction = SKAction.run {
            self.backgroundNode.position.y = 0
        }
        
        //Move map downwards
        self.backgroundNode.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: -screenHeight!/2, duration: 3),
                    reloadMapAction
                ])
            )
            
        )
        
        /*
        // ADD lvl 1 boss
        let lvlOne = LevelOneBoss(size: CGSize(width: 100, height: 100), imageNamed: "playerFace")
        lvlOne.position = CGPoint(x: 0, y: 200)
        lvlOne.player = self.mainCharacter
        self.addChild(lvlOne)
        
        lvlOne.shootHomingMissile()
        */
        
        //Add player in the middle
        let player = Player(size: CGSize(width: 60, height: 60), imageNamed: "player_back")
        player.position = CGPoint.zero
        self.addChild(player)
        player.walk()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for each in monsters {
            each.moveRandom()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.count == 1 {
            //only allow 1 touch
            let location = touches.first?.location(in: self)
            //print("Touch location: \(location)")
            //print("AtPoint: \(self.atPoint(location!))")
            
            if let object = self.atPoint(location!) as? AirShip {
                object.position = location!
            }
            
        }
        
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    ////Custom funcs
    func randomCoordinates() -> CGPoint {
        
        let widthBoundary = self.frame.width/2
        let heightBoundary = self.frame.height/2
        
        let randomWidth = CGFloat(drand48()) * (widthBoundary * 2) - widthBoundary
        let randomHeight = CGFloat(drand48()) * (heightBoundary * 2) - heightBoundary
        
        return CGPoint(x: randomWidth, y: randomHeight)
    }
    
    func monsterDidCollideWithMainChar(monster: SKSpriteNode, mainChar: SKSpriteNode) {
        print("Monster and MainChar collided")
    }
    
    func monsterDidCollideWithBullet(monster: SKSpriteNode, bullet: SKSpriteNode) {
        print("Monster got hit")
        (monster as? Monster)?.damagedByBullet()
        bullet.removeFromParent()
    }
    
    //MAp related
    func updateMainCharPosition() {
        let pos = self.mainCharacter?.position
        let tileRowIndex = self.backgroundNode.tileRowIndex(fromPosition: pos!)
        let tileColIndex = self.backgroundNode.tileColumnIndex(fromPosition: pos!)
        print("Tile Index Row: \(tileRowIndex), Column: \(tileColIndex)")
    }
    
}


//MARK: Physics Delegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact!!")
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
        
        //Monster and MainChar
        if (first.categoryBitMask == PhysicsCategory.Monster && second.categoryBitMask == PhysicsCategory.Player) {
            self.monsterDidCollideWithMainChar(monster: first.node as! SKSpriteNode, mainChar: second.node as! SKSpriteNode)
        }
        
        //Monster and Bullet
        if (first.categoryBitMask == PhysicsCategory.Monster && second.categoryBitMask == PhysicsCategory.Bullet) {
            //remove bullet
            if let monster = first.node as? Monster, let bullet = second.node as? Bullet {
                self.monsterDidCollideWithBullet(monster: monster, bullet: bullet)
            }
            
        }

        
    }
}

///

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
}

//Monster delegate

extension GameScene: MonsterDelegate {
    func monsterGotHit(hpLeft: Int, hpFull: Int) {
        self.hpLabel?.text = "Boss HP: \(hpLeft)"
        
        //Change HP guage bar
        let fullGuage = 200
        let fullHP = hpFull
        
        let currentHPRatio = Double(hpLeft)/Double(fullHP)
        
        let currentGuage = Double(fullGuage) * currentHPRatio
        
        print("Curren Guage: \(currentGuage)")
        self.hpGuage?.frame.size.width = CGFloat(currentGuage)
        
    }
}

extension GameScene: AirShipDelegate {
    func airShipMoved() {
        self.updateMainCharPosition()
    }
}

//Util func
class SceneUtility {
    class func convertSceneCoorToViewCoor(scene: SKScene, convertingPoint: CGPoint) -> CGPoint {
        return scene.convert(convertingPoint, from: scene)
    }
}

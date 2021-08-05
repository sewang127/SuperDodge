//
//  StoreScene.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/6/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//

import SpriteKit

class StoreScene: GameStage {
    
    var attackUp: SKSpriteNode?
    var defenceUp: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setupLayout()
        
    }
    
    func setupLayout() {
        
        let viewWidth = self.view!.frame.width
        let viewHeight = self.view!.frame.height
        
        //Temp Label
        attackUp = SKSpriteNode(imageNamed: "atkUp")
        
        //Place attack up in upper right
        attackUp?.size = CGSize(width: (viewWidth/2) * 0.4 , height: (viewHeight/2) * 0.2)
        
        let attackUpPos = CGPoint(x: (viewWidth/2) - 20, y: (viewHeight/2) - 20)
        attackUp?.anchorPoint = CGPoint(x: 1, y: 1)
        attackUp?.position = attackUpPos
        self.addChild(attackUp!)
        
        //DEF up
        defenceUp = SKSpriteNode(imageNamed: "defUp")
        
        //Place attack up in upper right
        defenceUp?.size = CGSize(width: (viewWidth/2) * 0.4 , height: (viewHeight/2) * 0.2)
        
        let defenceUpPos = CGPoint(x: (viewWidth/2) - 20, y: (viewHeight/2) - 40 - attackUp!.size.height)
        defenceUp?.anchorPoint = CGPoint(x: 1, y: 1)
        defenceUp?.position = defenceUpPos
        self.addChild(defenceUp!)
        
        //Add gold coin
        super.makeGoldCoinAppearRandom()
    }
    
}

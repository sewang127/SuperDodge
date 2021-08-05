//
//  PlayerData.swift
//  SuperDodge
//
//  Created by Se Wang Oh on 11/7/17.
//  Copyright © 2017 Se Wang Oh. All rights reserved.
//


//Singleton class for managing player data
class PlayerData {
    
    static let sharedInstance = PlayerData()
    private init(){}
    
    var playerCoin: Int = 0
    
}

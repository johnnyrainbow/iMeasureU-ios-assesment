//
//  Player.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import Foundation

class Player {
    static var players = [Player]()

    var attributes : [String : String] = [String:String]()
    
    init() {
        Player.players.append(self)
    }
   
}

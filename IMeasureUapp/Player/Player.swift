//
//  Player.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

class Player {
    static var players = [Player]()

    var attributes : [String : String] = [String:String]()
    
    init() {
        Player.players.append(self)
    }
    
    static func displayPlayers(players : [Player]) {//Util func
        players.forEach { player in
            print(player.attributes)
        }
    }
}

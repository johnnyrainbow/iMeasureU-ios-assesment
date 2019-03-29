//
//  ViewController.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import UIKit
import CSV //simple lib to read csv
import Foundation

extension Character { //Extension to provide a simple method to get ascii value of char
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}

class ViewController: UIViewController {
    var players = [Int]()
    var dateUtil = DateUtil()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let csv:CSVReader = CSVUtil.readCSV() 
        
        CSVUtil.populatePlayerData(csv: csv)
        
        //TODO write tests
        let sortedPlayers = Sorting.sort(key:"first_name", ascending:false) //sort by key
        print("---- SORTED ---- ")
        Player.displayPlayers(players: sortedPlayers)

        print("---- FILTERED QUERY ---- ")
        var filteredPlayers = Sorting.filterQuery(key: "college", query: "Lo")
        Player.displayPlayers(players: filteredPlayers)
        
        print("---- FILTERED BOUNDS ---- ")
        filteredPlayers = Sorting.filterBounds(key: "years_in_league", lowerBound: 5, upperBound: 8)
        Player.displayPlayers(players: filteredPlayers)

    }   
}


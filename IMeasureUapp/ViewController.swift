//
//  ViewController.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import UIKit
import CSV //simple way to read csv files TODO reference non lib way
import Foundation
extension Character {
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}
class ViewController: UIViewController {
    var players = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readCSV()
    }
  
    func readCSV() {
        //Get the path of the csv file
        let file_url = Bundle.main.path(forResource: "players_sample", ofType: "csv")
        
        //Create a readable stream for the file
        let stream = InputStream(fileAtPath: file_url!)!
        
        //Pass into CSVReader
        let csv = try! CSVReader(stream: stream,hasHeaderRow: true)
        
        traverseRows(csv: csv)
        
        sort(key:"first_name")
        displayPlayers()
    }
    func displayPlayers() {//Util func
        Player.players.forEach { player in
            print(player.attributes)
        }
    }
    func traverseRows(csv: CSVReader) {
        //First row is headers
        let headerRow = csv.headerRow!
        
        while let row = csv.next() {
            //We want to define a generic system that takes a row header and creates a key for a player by that value.
        
            let p = Player() //Declare a new player
            
            //Iterate header keys
            headerRow.forEach { key in
                parse(player: p, key:key,csv:csv)
            }
        }
    }
  
    func sort(key: String) {
        //Get all players in the list
        //sort by their dict[key] values
        //TODO google parse data before sorting swift.
            Player.players = Player.players.sorted(by: { stringParser(value: $0.attributes[key]!) > stringParser(value:$1.attributes[key]!)
            })
    }
    func isDate(value:String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        
        if dateFormatterGet.date(from: value) != nil {
            return true
        }
        return false
    }
    func stringParser(value: String) -> Int { //TODO move to Parser.
        if(isInt(string: value)) {
            return Int(value)!
        } else if(isDate(value: value)) {
            
        print("is date")
        } else {//do a date checker also
            //Is String
           return value[value.startIndex].asciiValue
        }
        return -1;
    }
    func isInt(string: String) -> Bool { //Move to Util class
        return Int(string) != nil
    }
    func parse(player : Player, key:String, csv:CSVReader) {
        if(csv[key] != nil) {
            //Consider a condition to check for header = "" on key,
            //since data with no key could be considered undesirable.
        
            player.attributes[key.lowercased()] = csv[key]!
        }
    }

}


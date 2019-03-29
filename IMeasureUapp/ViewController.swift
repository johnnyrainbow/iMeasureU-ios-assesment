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
        print(Player.players[0].attributes)
    }
    func traverseRows(csv: CSVReader) {
        
        //First row is headers
        let headerRow = csv.headerRow!
        
        while let row = csv.next() {
            //We want to define a generic system that takes any row headers and populates the class instances by that value.
            
            //Iterate over each header
            let p = Player() //Declare a new player
            headerRow.forEach { key in
                parse(player: p, key:key,csv:csv)
            }
        }
    }
    func parse(player : Player, key:String, csv:CSVReader) {
        if(csv[key] != nil) {
            //Consider a condition to check for header = "" on key, since data with no key is undesirable.
            player.attributes[key] = csv[key]!
        }
    }

}


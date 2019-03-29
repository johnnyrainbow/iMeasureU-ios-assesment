//
//  CSVReader.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import Foundation
import CSV

class CSVUtil { //Static Util class
    static var headerRow = [String]()
     static func readCSV() -> CSVReader {
        //Get the path of the csv file
        let file_url = Bundle.main.path(forResource: "players_sample", ofType: "csv")
        
        //Create a readable stream for the file
        let stream = InputStream(fileAtPath: file_url!)!
        
        //Pass into CSVReader
        let csv = try! CSVReader(stream: stream,hasHeaderRow: true)
        return csv
    }
    
     static func populatePlayerData(csv: CSVReader) {
        //First row is headers
        headerRow = csv.headerRow!
        
        while let row = csv.next() {
            //We define a generic system that takes a row header and creates a key for a player by that value.
            let p = Player() //Declare a new player
            //Iterate header keys
            headerRow.forEach { key in
                Parser.parse(player: p, key:key,csv:csv)
            }
        }
    }
}

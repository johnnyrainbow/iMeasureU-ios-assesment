//
//  Parser.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import Foundation
import CSV 

class Parser { //Static Util class
    
    static func isInt(string: String) -> Bool { //Move to Util class
        return Int(string) != nil
    }
    static func parse(player : Player, key:String, csv:CSVReader) {
        if(csv[key] != nil) {
            //Consider a condition to check for header = "" on key,
            //since data with no key could be considered undesirable.
            
            player.attributes[key.lowercased()] = csv[key]!
        }
    }
    static func sort(key: String) {
        //Get all players in the list
        //sort by their dict[key] values
        //TODO google parse data before sorting swift.
        Player.players = Player.players.sorted(by: { Parser.stringParser(value: $0.attributes[key]!) > Parser.stringParser(value:$1.attributes[key]!)
        })
    }
    
    static func stringParser(value: String) -> Int { //TODO move to Parser.
        if(isInt(string: value)) {
            return Int(value)!
        } else if(DateUtil.isDate(value: value)) {
            let dateArray = value.components(separatedBy: " ")
            let monthVal = DateUtil.monthConverter(month: dateArray[0])
            var monthString = String(monthVal)
            if(monthVal < 10) {
                monthString = "0" + String(monthVal)
            }
            
            var date = DateUtil.dateFormatter(month: monthString, day: dateArray[1], year: dateArray[2])
            // convert Date to TimeInterval (typealias for Double)
            //let timeInterval = someDate.timeIntervalSince1970
            
            // convert to Integer
            // let myInt = Int(timeInterval)
            //  return myInt
        } else {//do a date checker also
            //Is String
            return value[value.startIndex].asciiValue
        }
        return -1;
    }
    
}

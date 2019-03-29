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
    
    static func stringParser(value: String) -> Int { //TODO move to Parser.
        if(isInt(string: value)) {
            return Int(value)!
        } else if(DateUtil.isDate(value: value)) {
            //Convert string to date
            let date = parseDateCSVString(value: value)
            //Convert Date to TimeInterval (typealias for Double)
            let timeInterval = date.timeIntervalSince1970
            //Return date as an Int
            return Int(timeInterval)
        }
        //Is String
        return value[value.startIndex].asciiValue
    }
    
    static func parseDateCSVString(value: String) -> Date {
        let dateArray = value.components(separatedBy: " ")
        let monthVal = DateUtil.monthConverter(month: dateArray[0])
        var monthString = String(monthVal)
        if(monthVal < 10) { //eg 09 string instead of 9
            monthString = "0" + String(monthVal)
        }
        let date = DateUtil.dateFormatter(month: monthString, day: dateArray[1], year: dateArray[2])
        return date!
    }
}

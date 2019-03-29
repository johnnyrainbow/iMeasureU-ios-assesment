//
//  DateUtil.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 29/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import Foundation

class DateUtil { //Static Util class
    static var valid_months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    static func isDate(value:String) -> Bool {
        let dateArray = value.components(separatedBy: " ")
        
        if(dateArray.count == 3 && valid_months.contains(dateArray[0])) {
            return true
        }
        return false
    }
    
    static func monthConverter(month:String) ->Int {
        return valid_months.firstIndex(of: month)! + 1 //Index begins at 0
    }
    
    static func dateFormatter(month:String, day:String, year:String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from:  year + "-" + month + "-" + day)

        return convertedDate
    }
}

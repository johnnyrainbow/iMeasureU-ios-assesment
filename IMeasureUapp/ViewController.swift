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
       let csv = CSVUtil.readCSV()
        
        CSVUtil.traverseRows(csv: csv);
        
        Parser.sort(key:"dob")
        Player.displayPlayers()
    }   
}


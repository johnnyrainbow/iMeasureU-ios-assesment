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
struct cellData {
    var first_name = String()
    var last_name = String()
    var number = String()
    var position = String()
    var dob = String()
    var country = String()
    var yearsInLeague = String()
    var college = String()
}
class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var college: UILabel!
    @IBOutlet weak var country: UILabel!
}
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableViewData = [cellData]()
    var players = [Int]()
    var dateUtil = DateUtil()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = "cell"
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        let csv:CSVReader = CSVUtil.readCSV()
        CSVUtil.populatePlayerData(csv: csv)
        
        //for each player
        
        Player.players.forEach { player in
            print(player.attributes)
           
            tableViewData.append(
                cellData(first_name: player.attributes["first_name"]!, last_name:player.attributes["last_name"]!,
                number: player.attributes["number"]!,
                position: player.attributes["position"]!,
                dob: player.attributes["dob"]!,
                country: player.attributes[""]!,
                yearsInLeague: player.attributes["years_in_league"]!,
                college:player.attributes["college"]!))
        }
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
   
     func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! HeadlineTableViewCell
        var data = tableViewData[indexPath.section]
        cell.fullName?.text = data.first_name + " " + data.last_name
        if(Parser.isInt(string:data.number)){
            data.number = "#" + data.number
        }
        cell.number?.text = data.number
        cell.position?.text = data.position
        cell.college?.text = data.college
        cell.country?.text = data.country.uppercased()
        cell.dob?.text = data.dob
        cell.dob.center = self.view.center
        cell.years?.text = data.yearsInLeague
       // cell.fullName.sizeToFit()
      
        return cell
    }
}


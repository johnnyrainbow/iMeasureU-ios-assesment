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

//The data that a typical UITableView cell will contain
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

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var tableViewData = [cellData]()
    var players = [Int]()
    var dateUtil = DateUtil()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = "cell"
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let csv:CSVReader = CSVUtil.readCSV()
        CSVUtil.populatePlayerData(csv: csv)
        
        //for each player, populate cell data.
        populateTableViewData(players:Player.players)
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
    
    func populateTableViewData(players: [Player]) {
        players.forEach { player in
            tableViewData.append(
                cellData(first_name: player.attributes["first_name"]!, last_name:player.attributes["last_name"]!,
                         number: player.attributes["number"]!,
                         position: player.attributes["position"]!,
                         dob: player.attributes["dob"]!,
                         country: player.attributes[""]!,
                         yearsInLeague: player.attributes["years_in_league"]!,
                         college:player.attributes["college"]!))
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        var filteredPlayers = [Player]()
        
        if(searchText == "" ) { //Empty search string, display original data
           filteredPlayers = Player.players
        } else {
            filteredPlayers = Sorting.anyKeyFilterQuery(query: searchText, strict:false)
        }
 
        tableViewData.removeAll()
        populateTableViewData(players:filteredPlayers)
       
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! PlayerTableViewCell
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


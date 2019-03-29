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
    var currentSearchQuery:String = ""
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = "cell"
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        // This view controller itself will provide the delegate methods and row data for the table view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let csv:CSVReader = CSVUtil.readCSV()
        CSVUtil.populatePlayerData(csv: csv)
        
        //for each player, populate cell data.
        populateTableViewData(players:Player.players)
        //TODO write tests
        let sortedPlayers = Sorting.sort(players: Player.players, key:"first_name", ascending:false) //sort by key
        print("---- SORTED ---- ")
        Player.displayPlayers(players: sortedPlayers)

        print("---- FILTERED QUERY ---- ")
        var filteredPlayers = Sorting.filterQuery(players: Player.players, key: "college", query: "Lo")
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
                         country: player.attributes["country"]!,
                         yearsInLeague: player.attributes["years_in_league"]!,
                         college:player.attributes["college"]!))
        }
        Player.currentPlayerList = players //Update the current player list
    }
    func sortQuery(query:String) -> [Player] {
        var filteredPlayers = Player.players
        
        if(query != "" ) {
            filteredPlayers = Sorting.anyKeyFilterQuery(players: Player.players, query: query, strict:false)
        }
        //Empty search string, display original data
        return filteredPlayers
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reset picker
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        let filteredPlayers = sortQuery(query: searchText)
        Player.displayPlayers(players: filteredPlayers)
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
        cell.years?.text = data.yearsInLeague
       // cell.fullName.sizeToFit()
      
        return cell
    }
}
extension TableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //New option picked
        print(CSVUtil.headerRow[row])
        let players = Player.currentPlayerList;
       
        let sortedPlayers = Sorting.sort(players: players, key:CSVUtil.headerRow[row], ascending:true) //sort by key
        tableViewData.removeAll()
        populateTableViewData(players:sortedPlayers)
        tableView.reloadData()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CSVUtil.headerRow.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        detailLabel.text = CSVUtil.headerRow[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CSVUtil.headerRow[row]
    }
}


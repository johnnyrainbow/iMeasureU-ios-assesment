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

class ViewController: UIViewController {
   
    var tableViewData = [cellData]()
    var players = [Int]()
    var dateUtil = DateUtil()
    var currentSearchQuery:String = ""
    
    //UIOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = "cell"
        //Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        //Set to custom BG
        self.tableView.backgroundColor = UIColor.init(red: 14/255, green: 33/255, blue: 84/255, alpha: 1.0)
        //Semoves empty cell lines
        tableView.tableFooterView = UIView()
        //Assign delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        searchBar.delegate = self
        
        let csv:CSVReader = CSVUtil.readCSV()
        CSVUtil.populatePlayerData(csv: csv)
        
        //For each player, populate cell data.
        populateTableViewData(players:Player.players)
    }
    
    //Use set attributes for UI related data display
    func populateTableViewData(players: [Player]) {
        players.forEach { player in
            tableViewData.append(
                cellData(
                    first_name: player.attributes["first_name"]!,
                    last_name:player.attributes["last_name"]!,
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
}



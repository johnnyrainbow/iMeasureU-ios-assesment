//
//  TableViewControllerExtensions.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 30/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//

import Foundation
import UIKit

//Searchbar extension
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reset picker
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        let filteredPlayers = sortQuery(query: searchText)
        Player.displayPlayers(players: filteredPlayers)
        tableViewData.removeAll()
        populateTableViewData(players:filteredPlayers)
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
//TableView extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        return cell
    }
}

//UIPicker extension
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //New option picked
        let players = Player.currentPlayerList;
        //sort by key
        let sortedPlayers = Sorting.sort(players: players, key:CSVUtil.headerRow[row], ascending:true)
        
        tableViewData.removeAll()
        populateTableViewData(players:sortedPlayers)
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CSVUtil.headerRow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CSVUtil.headerRow[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: CSVUtil.headerRow[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
}

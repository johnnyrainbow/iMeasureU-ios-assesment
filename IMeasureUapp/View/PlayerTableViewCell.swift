//
//  PlayerTableViewCell.swift
//  IMeasureUapp
//
//  Created by Gabriel Kennedy on 30/03/19.
//  Copyright © 2019 Gabriel Kennedy. All rights reserved.
//
import UIKit

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

//Custom cell class for displaying player info
class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var college: UILabel!
    @IBOutlet weak var country: UILabel!
}

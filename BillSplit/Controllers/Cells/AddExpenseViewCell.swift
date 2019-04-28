//
//  AddExpenseUserCell.swift
//  BillSplit
//
//  Created by Nicolas Guary on 28/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseViewCell: UITableViewCell {
    var user: UserModel?
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var participateSwitch: UISwitch!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
}

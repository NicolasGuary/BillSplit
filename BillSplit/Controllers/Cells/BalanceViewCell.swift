//
//  BalanceViewCell.swift
//  BillSplit
//
//  Created by Nicolas Guary on 01/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class BalanceViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstUserAvatar: UIImageView!
    @IBOutlet weak var secondUserAvatar: UIImageView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var firstUserName: UILabel!
    @IBOutlet weak var secondUserName: UILabel!
}

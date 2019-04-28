//
//  MemberViewCell.swift
//  BillSplit
//
//  Created by Nicolas Guary on 20/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import UIKit

class MemberViewCell: UICollectionViewCell {
    var user: UserModel?
    
    @IBOutlet weak var memberPicture: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
}

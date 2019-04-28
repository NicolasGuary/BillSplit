//
//  CellStyle.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class CellStyle{
    //This creates the shadows and modifies the cards a little bit
    static func customizeCell(cell: UICollectionViewCell){
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}

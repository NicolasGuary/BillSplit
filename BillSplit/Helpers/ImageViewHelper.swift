//
//  ImageViewHelper.swift
//  BillSplit
//
//  Created by Nicolas Guary on 28/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded(borderWidth: CGFloat = 0.0, borderColor: UIColor = UIColor.clear) {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

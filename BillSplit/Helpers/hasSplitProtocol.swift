//
//  hasSplitProtocol.swift
//  BillSplit
//
//  Created by Nicolas Guary on 26/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation

//Used to encapsulate controllers that owns a Split. It can be implemented for instance in this case by sub-controllers of the Tab Bar to get the selected Split
protocol hasSplitProtocol {
    var split: SplitModel? {
        get set
    }
}

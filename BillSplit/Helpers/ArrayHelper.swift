//
//  ArrayHelper.swift
//  BillSplit
//
//  Created by Nicolas Guary on 27/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation

extension Array where Element: Equatable  {
    mutating func delete(element: Iterator.Element) {
        self = self.filter{$0 != element }
    }
}

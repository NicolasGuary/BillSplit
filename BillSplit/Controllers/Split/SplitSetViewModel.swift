//
//  SplitSetViewModel.swift
//  BillSplit
//
//  Created by Nicolas Guary on 01/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData

protocol SplitSetViewModelDelegate {
    func dataSetChanged()
}

class SplitSetViewModel {
    var delegate: SplitSetViewModelDelegate? = nil
    var splitFetched: [SplitModel]
    
    init(data: [SplitModel]) {
        self.splitFetched = data
    }
    
    public func add(split: SplitModel) {
        Split.save()
        splitFetched.append(split)
        self.delegate?.dataSetChanged()
    }
    
    public func delete(at indexPath: IndexPath) {
        splitFetched[indexPath.row].delete()
        splitFetched.remove(at: indexPath.row)
        Split.save()
        self.delegate?.dataSetChanged()
    }
    
    public func get(splitAt index: Int) -> SplitModel? {
        return self.splitFetched[index]
    }
    
    public var count: Int{
        return self.splitFetched.count
    }
}

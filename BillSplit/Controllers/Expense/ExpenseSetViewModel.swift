//
//  ExpenseSetViewModel.swift
//  BillSplit
//
//  Created by Nicolas Guary on 03/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData

protocol ExpenseSetViewModelDelegate {
    func dataSetChanged()
}

class ExpenseSetViewModel {
    var delegate: ExpenseSetViewModelDelegate? = nil
    var expenseFetched: [ExpenseModel]
    
    init(data: [ExpenseModel]) {
        self.expenseFetched = data
    }
    
    public func add(expense: ExpenseModel) {
        Expense.save()
        expenseFetched.append(expense)
        self.delegate?.dataSetChanged()
    }
    
    public func delete(at indexPath: IndexPath) {
        expenseFetched[indexPath.row].delete()
        expenseFetched.remove(at: indexPath.row)
        Expense.save()
        self.delegate?.dataSetChanged()
    }
    
    public func get(expenseAt index: Int) -> ExpenseModel? {
        return self.expenseFetched[index]
    }
    
    public var count: Int{
        return self.expenseFetched.count
    }
}

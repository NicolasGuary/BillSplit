//
//  ParticipateModel.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ParticipateModel{
    
    //We can use the CodeData model because we gave it the extension needed to be a DAO
    
    internal var dao : Participate
    
    var paidBy: Float {
        get{
            return (self.dao.paidBy*100).rounded() / 100
        }
        set{
            self.dao.paidBy = (newValue*100).rounded() / 100
        }
    }
    var paidFor: Float {
        get{
            return (self.dao.paidFor*100).rounded() / 100
        }
        set{
            self.dao.paidFor = (newValue*100).rounded() / 100
        }
    }
    
    var expense: Expense {
        get{
            return self.dao.expense!
        }
        set {
            self.dao.expense = newValue
        }
    }
    
    var user: User {
        get{
            return self.dao.user!
        }
        set {
            self.dao.user = newValue
        }
    }
    
    init(paidFor: Float, paidBy: Float, expense: ExpenseModel, user: UserModel){
        self.dao = Participate.create()
        self.dao.paidFor = (paidFor*100).rounded() / 100
        self.dao.paidBy = (paidBy*100).rounded() / 100
        self.expense = expense.dao
        self.user = user.dao
    }
    
    init(participate: Participate) {
        self.dao = participate
    }
}

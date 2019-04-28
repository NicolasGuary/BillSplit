//
//  ExpenseModel.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ExpenseModel {
    internal var dao : Expense
    
    var date: Date {
        get{
            return self.dao.date! as Date
        }
        set{
            self.dao.date = newValue as Date
        }
    }
    
    var picture: UIImage {
        get{
            return  UIImage(data: self.dao.picture!)!
        }
        set{
            self.dao.picture = UIImagePNGRepresentation(newValue)
        }
    }
    
    var title: String {
        get{
            return self.dao.title!
        }
        set{
            self.dao.title = newValue
        }
    }
    
    var totalAmount: Float {
        get{
            return self.dao.totalAmount
        }
        set{
            self.dao.totalAmount = newValue
        }
    }
    
    var split : Split {
        get{
            return self.dao.split!
        }
        set {
            self.dao.split = newValue
        }
    }
    
    var participates: [Participate] {
        get{
            if let exps = self.dao.participates?.allObjects as? [Participate] {
                return exps
            } else {
                return []
            }
        }
    }
    
    func delete() {
        Expense.delete(object: self.dao)
    }
    
    func getAllParticipate() -> [ParticipateModel]? {
        let participates = self.dao.participates?.allObjects as? [Participate]
        var participateModels: [ParticipateModel] = []
        if let parts = participates {
            for par in parts{
                participateModels.append(ParticipateModel(participate: par))
            }
        }
        
        return participateModels
    }
    
    init(date: Date, picture: UIImage, title: String, totalAmount: Float, split: SplitModel){
        self.dao = Expense.create()
        self.dao.date = date as Date
        self.dao.picture = UIImagePNGRepresentation(picture)
        self.dao.title = title
        self.dao.totalAmount = totalAmount
        self.dao.split = split.dao
    }
    
    init(expense: Expense) {
        self.dao = expense
    }
    
    
}

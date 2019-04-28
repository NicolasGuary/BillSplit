//
//  ExpenseDAO.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Expense {
    static func getNewExpenseDAO() -> Expense?{
        guard let entity = NSEntityDescription.entity(forEntityName: "Expense", in: CoreDataManager.context) else {
            return nil
        }
        return Expense(entity: entity, insertInto : CoreDataManager.context)
    }
    
    static func create() -> Expense{
        return Expense(context: CoreDataManager.context)
    }
    
    static func save() {
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to save: "+error.description)
        }
    }
    
    static func delete(object: Expense){
        do{
            try CoreDataManager.delete(object: object)
        }catch let error as NSError{
            fatalError("Unable to delete: "+error.description)
        }
    }
    
    static func addToParticipates(object: Expense, participate : Participate ){
        object.addToParticipates(participate)
        self.save()
    }
    
    static func removeFromParticipates(object: Expense, participate : Participate ){
        object.removeFromParticipates(participate)
        self.save()
    }
    
    
    static func modify(object: Expense) {
        object.setValue(object.date! as NSDate, forKey: "date")
        object.setValue(object.picture, forKey: "picture")
        object.setValue(object.title, forKey: "title")
        object.setValue(object.totalAmount, forKey: "totalAmount")
        object.setValue(object.participates, forKey: "participates")
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to update: "+error.description)
        }
    }
}

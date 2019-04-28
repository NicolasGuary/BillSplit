//
//  ParticipateDAO.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Participate {
    static func getNewParticipateDAO() -> Participate?{
        guard let entity = NSEntityDescription.entity(forEntityName: "Participate", in: CoreDataManager.context) else {
            return nil
        }
        return Participate(entity: entity, insertInto : CoreDataManager.context)
    }
    
    static func create() -> Participate{
        return Participate(context: CoreDataManager.context)
    }
    
    static func save() {
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to save: "+error.description)
        }
    }
    
    static func delete(object: Participate){
        do{
            try CoreDataManager.delete(object: object)
        }catch let error as NSError{
            fatalError("Unable to delete: "+error.description)
        }
    }
    
    
    static func modify(object: Participate) {
        object.setValue(object.paidBy, forKey: "paidBy")
        object.setValue(object.paidFor, forKey: "paidFor")
        object.setValue(object.expense, forKey: "expense")
        object.setValue(object.user, forKey: "user")
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to update: "+error.description)
        }
    }
}




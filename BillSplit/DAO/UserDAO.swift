//
//  UserDAO.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension User {
    static func getNewUserDAO() -> User?{
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: CoreDataManager.context) else {
            return nil
        }
        return User(entity: entity, insertInto : CoreDataManager.context)
    }
    
    static func create() -> User{
        return User(context: CoreDataManager.context)
    }
    
    static func save() {
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to save: "+error.description)
        }
    }
    
    static func delete(object: User){
        do{
            try CoreDataManager.delete(object: object)
        }catch let error as NSError{
            fatalError("Unable to delete: "+error.description)
        }
    }
    
    static func addToParticipates(object: User, participate : Participate ){
        object.addToParticipates(participate)
        self.save()
    }
    
    static func removeFromParticipates(object: User, participate : Participate ){
        object.removeFromParticipates(participate)
        self.save()
    }
    
    
    
    static func modify(object: User) {
        object.setValue(object.pseudo, forKey: "pseudo")
        object.setValue(object.photo, forKey: "photo")
        object.setValue(object.participates, forKey: "participates")
        object.setValue(object.split, forKey: "split")
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to update: "+error.description)
        }
    }
}

//
//  UserModel.swift
//  BillSplit
//
//  Created by Nicolas Guary on 25/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserModel {
    internal var dao : User
    
    var pseudo: String {
        get{
            return self.dao.pseudo!
        }
        set{
            self.dao.pseudo = newValue
        }
    }
        
    var avatar: UIImage {
        get{
            return  UIImage(data: self.dao.avatar!)!
        }
        set{
            self.dao.avatar = UIImagePNGRepresentation(newValue)
        }
    }
    
    var split: Split {
        get{
            return self.dao.split!
        }
        set{
            self.dao.split = newValue
        }
    }
    
    var arrivalDate: Date {
        get{
            return self.dao.arrivalDate! as Date
        }
        set{
            self.dao.arrivalDate = newValue as Date
        }
    }
    
    
    var participates: [Participate]? {
        get{
            if let exps = self.dao.participates?.allObjects as? [Participate] {
                return exps
            } else {
                return []
            }
        }
    }
    
    func delete() {
        User.delete(object: self.dao)
    }
    
    init(pseudo: String, avatar: UIImage, arrivalDate: Date, departureDate: Date, split: SplitModel){
        self.dao = User.create()
        self.dao.pseudo = pseudo
        self.dao.avatar = UIImagePNGRepresentation(avatar)
        self.dao.arrivalDate = arrivalDate
        self.dao.departureDate = departureDate
        self.dao.split = split.dao
    }
    
    init(user: User){
        self.dao = user
    }
}


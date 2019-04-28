
import Foundation
import CoreData
import UIKit

/// Extending the CodeData model to get access to the data

extension Split{
    
    static func getNewSplitDAO() -> Split?{
        guard let entity = NSEntityDescription.entity(forEntityName: "Split", in: CoreDataManager.context) else {
            return nil
        }
        return Split(entity: entity, insertInto : CoreDataManager.context)
    }
    
    static func create() -> Split{
        return Split(context: CoreDataManager.context)
    }
    
    static func save() {
        do{
            try CoreDataManager.save()
        }catch let error as NSError{
            fatalError("Unable to save: "+error.description)
        }
    }
    
    static func delete(object: Split){
        do{
            try CoreDataManager.delete(object: object)
        }catch let error as NSError{
            fatalError("Unable to delete: "+error.description)
        }
    }
    
    static func addToExpenses(object: Split, expense : Expense ){
        object.addToExpenses(expense)
        self.save()
    }
    
    static func removeFromExpenses(object: Split, expense : Expense ){
        object.removeFromExpenses(expense)
        self.save()
    }
    
    static func addToUsers(object: Split, user : User ){
        object.addToUsers(user)
        self.save()
    }
    
    static func removeFromUsers(object: Split, user : User ){
        object.removeFromUsers(user)
        self.save()
    }
    
    
    static func modify(object: Split) {
            object.setValue(object.title, forKey: "title")
            object.setValue(object.descr, forKey: "descr")
            object.setValue(object.currency, forKey: "currency")
            object.setValue(object.picture, forKey: "picture")
            object.setValue(object.endDate! as NSDate, forKey: "endDate")
            object.setValue(object.departureDate! as NSDate, forKey: "departureDate")
            
            object.setValue(object.expenses, forKey: "expenses")
            do{
                try CoreDataManager.save()
            }catch let error as NSError{
                fatalError("Unable to update: "+error.description)
            }
    }
}

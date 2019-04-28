import Foundation
import UIKit
import CoreData

/// Links the DAO with CoreData
class CoreDataManager{
    
    public static let context : NSManagedObjectContext  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Returns the entity
    public static func entity(forName name: String) -> NSEntityDescription{
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: self.context) else{
            fatalError()
        }
        return entity
    }
    
    //Save entity into context
    class func save() throws {
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
            throw error
        }
    }
    
    //Delete entity in context from CoreData
    class func delete(object: NSManagedObject) throws {
            CoreDataManager.context.delete(object)
    }
}

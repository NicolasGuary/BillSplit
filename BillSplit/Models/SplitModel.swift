import Foundation
import CoreData
import UIKit

class SplitModel{
    
    //We can use the CodeData model because we gave it the extension needed to be a DAO
    
    internal var dao : Split
    
    var departureDate: Date {
        get{
            return self.dao.departureDate! as Date
        }
        set{
            self.dao.departureDate = newValue as Date
        }
    }

    var endDate: Date {
        get{
            return self.dao.endDate! as Date
        }
        set{
            self.dao.endDate = newValue as Date
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
    
    var descr: String {
        get{
            return self.dao.descr!
        }
        set{
            self.dao.descr = newValue
        }
    }

    var currency: String {
        get{
            return self.dao.currency!
        }
        set{
            self.dao.currency = newValue
        }
    }

    var picture: UIImage {
        get{
            return UIImage(data: self.dao.picture!)!
        }
        set{
            self.dao.picture = UIImagePNGRepresentation(newValue)
        }
    }
    
    var expenses: [Expense] {
        get{
            if let exps = self.dao.expenses?.allObjects as? [Expense] {
                return exps
            } else {
                return []
            }
        }
    }
    
    func getAllExpenses() -> [ExpenseModel]? {
        let expenses = self.dao.expenses?.allObjects as? [Expense]
        var expensesModels: [ExpenseModel] = []
        if let expense = expenses {
            for exp in expense{
                expensesModels.append(ExpenseModel(expense: exp))
            }
        }
        
        return expensesModels
    }
    
    func getAllUsers() -> [UserModel]? {
        let users = self.dao.users?.allObjects as? [User]
        var usersModels: [UserModel] = []
        if let us = users {
            for u in us{
                usersModels.append(UserModel(user: u))
            }
        }
        
        return usersModels
    }
    
    static func addToUsers(split: SplitModel, user : UserModel ){
       Split.addToUsers(object: split.dao, user: user.dao)
    }
    
    static func removeFromUsers(split: SplitModel, user : UserModel ){
       Split.removeFromUsers(object: split.dao, user: user.dao)
    }
    
    func delete(){
        Split.delete(object: self.dao)
    }
    
    
    static func fetchAllSplits() -> [SplitModel]? {
        let context = CoreDataManager.context
        let request : NSFetchRequest<Split> = Split.fetchRequest()
        var splits: [Split]?
        var splitModels: [SplitModel] = []
        do{
            try splits = context.fetch(request)
        }
        catch {
            fatalError()
        }
        if let s = splits {
            for split in s{
                splitModels.append(SplitModel(split: split))
            }
        }
        
        return splitModels
        
    }
    
    
    func update() {
        Split.modify(object: self.dao)
    }
    
    init(title: String, descr: String, picture: UIImage, currency: String, departureDate: NSDate, endDate: NSDate){
        self.dao = Split.create()
        self.dao.departureDate = departureDate as Date
        self.dao.endDate = endDate as Date
        self.dao.title = title
        self.dao.descr = descr
        self.dao.currency = currency
        self.dao.picture = UIImagePNGRepresentation(picture)
    }
    
    init(title: String, descr: String, picture: UIImage, currency: String, departureDate: NSDate, endDate: NSDate, users: [User]){
        self.dao = Split.create()
        self.dao.departureDate = departureDate as Date
        self.dao.endDate = endDate as Date
        self.dao.title = title
        self.dao.descr = descr
        self.dao.currency = currency
        self.dao.picture = UIImagePNGRepresentation(picture)
    }
    
    init(split: Split){
        self.dao = split
    }
}

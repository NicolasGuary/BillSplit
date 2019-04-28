//
//  ExpenseViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 27/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import UIKit
import CoreData
class ExpenseViewController:UIViewController, hasSplitProtocol {
    var expenseTableController: ExpenseTableController?
    var split: SplitModel?
    
    @IBOutlet weak var expensesTableView: UITableView!
    
    //@TODO Reccup le split en se mettant dans le protocol hasSPlit et fetch en jointure
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expenseTableController = ExpenseTableController(tableView: self.expensesTableView, split: self.split!)
    }

    @IBAction func unwindToViewExpenses(sender: UIStoryboardSegue){
        if let controller = sender.source as? AddExpenseViewController{
            if sender.identifier == "saveExpense"{
                if let newExpense = controller.newExpense {
                    self.expenseTableController?.expenseSetViewModel.add(expense: newExpense)
                }
            } else if sender.identifier == "deleteExpense"{
                 if let deletedExpense = controller.index {
                    self.expenseTableController?.expenseSetViewModel.delete(at: deletedExpense)
                }
            }
        }
        
        if let tbk = self.expensesTableView {
            tbk.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddExpenseViewController{
            if let cell = sender as? ExpenseViewCell {
                if let indexPath = self.expensesTableView!.indexPath(for: cell){
                    controller.expense = self.expenseTableController?.expenseSetViewModel.get(expenseAt: indexPath.row) 
                    controller.split = self.split
                    controller.index = indexPath
                }
            }
        }
    }
}

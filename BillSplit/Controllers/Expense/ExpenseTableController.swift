//
//  expenseTableController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 03/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import UIKit

class ExpenseTableController: NSObject, UITableViewDataSource, ExpenseSetViewModelDelegate {
    
    var expenseSetViewModel: ExpenseSetViewModel
    var tableView: UITableView
    var split: SplitModel?

    init(tableView: UITableView, split: SplitModel) {
        self.tableView = tableView
        self.split = split
           
        if let expenseModels = split.getAllExpenses()  {
            self.expenseSetViewModel = ExpenseSetViewModel(data: expenseModels)
        }
        else {
            self.expenseSetViewModel = ExpenseSetViewModel(data: [] )
        }
        
        
        
        super.init()
        self.tableView.dataSource = self
        self.expenseSetViewModel.delegate = self
    }
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return self.expenseSetViewModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellExpense", for: indexPath) as! ExpenseViewCell
        if let expense = self.expenseSetViewModel.get(expenseAt: indexPath.row) {
            let currency = self.split!.currency
            cell.amountLabel.text = String(expense.totalAmount) + currency
            cell.expenseDate.text = Date.toString(date: expense.date)
            cell.expenseName.text = expense.title
            var paidByLabel = ""
            if let participates = expense.getAllParticipate() {
                for part in participates {
                    if part.paidBy > 0 {
                        paidByLabel += ", \(part.user.pseudo ?? "")"
                    }
                }
                if paidByLabel == "" {
                    paidByLabel = "Paid by null"
                }
                paidByLabel = String(paidByLabel[1..<paidByLabel.count])
            }
            cell.userName.text = paidByLabel
        }
        
        
        return cell
    }
    
    func dataSetChanged() {
        self.tableView.reloadData()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

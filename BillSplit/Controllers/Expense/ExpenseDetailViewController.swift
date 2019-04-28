//
//  ExpenseDetailViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 03/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import UIKit
import CoreData

class ExpenseDetailViewController: UIViewController {
    var split: SplitModel? = nil
    var expense: ExpenseModel? = nil
    var newExpense: ExpenseModel? = nil

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = expense?.picture

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddExpenseViewController{
            controller.split = self.split
            controller.expense = self.expense
            controller.newExpense = self.newExpense
        }
    }
}

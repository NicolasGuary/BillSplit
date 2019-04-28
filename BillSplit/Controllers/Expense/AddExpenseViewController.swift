//
//  AddExpenseViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 28/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class AddExpenseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var paidByTable: UITableView!
    @IBOutlet weak var paidForTable: UITableView!
    @IBOutlet weak var paidByTotal: UILabel!
    @IBOutlet weak var paidForTotal: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var expenseNameTextField: UITextField!

    @IBOutlet weak var imageExpense: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var newExpense: ExpenseModel?

    var split: SplitModel!
    var users: [UserModel] = []
    var index: IndexPath?
    var expense: ExpenseModel?
    var participates: [ParticipateModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyLabel.text = self.split.currency
        
        if let exp = self.expense {
            // Initialisation UPDATE expense
            if let participates = exp.getAllParticipate() {
                for p in participates {
                    users.append(UserModel(user: p.user))
                }
                self.imageExpense.setImage(exp.picture, for: .normal)
                self.totalExpense.text = String(exp.totalAmount)
                self.expenseNameTextField.text = exp.title
                self.dateTextField.text = Date.toString(date: exp.date)
                self.participates = participates
               
            }
        } else {
            if let users = self.split.getAllUsers() {
                self.users = users
            }
            
            // Initialisation CREATE expense
            self.imageExpense.setImage(UIImage(named: "placeholder")!, for: .normal)
            self.dateTextField.text = Date.toString(date: Date.currentDate())
            self.deleteButton.isHidden = true
        }
    }
    
    
    // MARK - INIT TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AddExpenseViewCell
        
        if tableView == paidByTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "paidByCell") as! AddExpenseViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "paidForCell") as! AddExpenseViewCell
        }
        
        if let expense = self.expense {
            cell = initAddExpenseViewCellForUpdate(cell: cell, expense: expense, indexPath: indexPath)
        } else {
            cell = initAddExpenseViewCellForCreate(cell: cell,indexPath: indexPath)
        }
        
       
        return cell
        
    }
    
    func initAddExpenseViewCellForCreate (cell: AddExpenseViewCell, indexPath: IndexPath) -> AddExpenseViewCell{
        cell.userName.text = self.users[indexPath.row].pseudo
        cell.currencyLabel.text = self.split.currency
        cell.amountTextField.text = "0"
        cell.userAvatar.image = self.users[indexPath.row].avatar
        cell.userAvatar.setRounded()
        cell.user = users[indexPath.row]
        return cell
    }
    
    func initAddExpenseViewCellForUpdate (cell: AddExpenseViewCell, expense: ExpenseModel, indexPath: IndexPath) -> AddExpenseViewCell {
        cell.userName.text = self.users[indexPath.row].pseudo
        cell.currencyLabel.text = self.split.currency
        cell.userAvatar.image = self.users[indexPath.row].avatar
        cell.userAvatar.setRounded()
        cell.user = users[indexPath.row]
        if cell.reuseIdentifier == "paidForCell" {
            if expense.participates[indexPath.row].paidFor > 0 {
                cell.participateSwitch.setOn(true, animated: false)
                enable(cell: cell)
                cell.amountTextField.text = String(expense.participates[indexPath.row].paidFor)
            } else {
                 cell.participateSwitch.setOn(false, animated: false)
                 disable(cell: cell)
                
            }
            
        } else if cell.reuseIdentifier == "paidByCell" {
            if expense.participates[indexPath.row].paidBy > 0 {
                cell.participateSwitch.setOn(true, animated: false)
                enable(cell: cell)
                cell.amountTextField.text = String(expense.participates[indexPath.row].paidBy)
            }
            else {
                cell.participateSwitch.setOn(false, animated: false)
                disable(cell: cell)
            
            }
        }
        
        return cell
    }
    
    // END INIT TABLE VIEW
    
    
    @IBAction func listenerSwitchPaidBy(_ sender: Any) {
        computePaidBy()
        manageSaveButton()
    }
    
    @IBAction func listenerSwitchPaidFor(_ sender: Any) {
        computePaidFor()
        manageSaveButton()
    }
    
    
    func computePaidBy() {
        let cells = self.paidByTable.visibleCells as! Array<AddExpenseViewCell>
        let separateAmount = getBalanceAmount(cells: cells)
        
        // Put 0 in unactivated person and compute the total paid
        for cell in cells {
            
            if cell.participateSwitch.isOn {
                self.enable(cell: cell)
                if !self.touchedPaidBy {
                    cell.amountTextField?.text = String(separateAmount)
                }
            } else {
                self.disable(cell: cell)
            }
        }
        
        let totalPaidByFromField = getTotalPaid(cells: cells)
        managedDisplayTotal(total: totalPaidByFromField, displayTotal: self.paidByTotal)
    }
    
    func computePaidFor() {
        // Division pour les paid for
        let cells = self.paidForTable.visibleCells as! Array<AddExpenseViewCell>
        let separateAmount = getBalanceAmount(cells: cells)
        
        for cell in cells {
            if cell.participateSwitch.isOn {
                self.enable(cell: cell)
                if !self.touchedPaidFor {
                    cell.amountTextField?.text = String(separateAmount)
                }
                //let amount = (cell.amountTextField.text! as NSString).floatValue
                //totalPaidFor += amount
            } else {
                self.disable(cell: cell)
            }
        }
        
        let totalPaidForFromField = getTotalPaid(cells: cells)
        managedDisplayTotal(total: totalPaidForFromField, displayTotal: self.paidForTotal)
    }
    
    func managedDisplayTotal(total: Float, displayTotal: UILabel) {
        let v = (self.totalExpense.text! as NSString).floatValue
        displayTotal.text = String(total)
        if total != v {
            displayTotal.textColor = UIColor.red
        } else {
            displayTotal.textColor = UIColor(red: 2, green: 195, blue: 154)

        }
    }
    
    
    func getTotalPaid(cells: [AddExpenseViewCell]) -> Float{
        var totalAmountPayed = Float(0)
        for cell in cells {
            if cell.participateSwitch.isOn {
                let v = (cell.amountTextField.text! as NSString).floatValue
                totalAmountPayed += v
            }
        }
        return totalAmountPayed
    }
    
    // Return the total amount divised by payers
    func getBalanceAmount(cells: [AddExpenseViewCell]) -> Float {
        var nbPaidFor = 0
        for cell in cells {
            if cell.participateSwitch.isOn {
                nbPaidFor += 1
            }
        }
        var div = Float(0)
        if nbPaidFor != 0 {
            let totalValue = (self.totalExpense.text! as NSString).floatValue
            div =  totalValue / Float(nbPaidFor)
        }
        return (div*100).rounded() / 100
    }
    
    func enable(cell: AddExpenseViewCell) {
        cell.amountTextField.isUserInteractionEnabled = true
        cell.amountTextField.textColor = UIColor(red: 2, green: 195, blue: 154)
        cell.currencyLabel.textColor = UIColor(red: 2, green: 195, blue: 154)
        
    }
    func disable(cell: AddExpenseViewCell) {
        cell.amountTextField.text = "0"
        cell.amountTextField.isUserInteractionEnabled = false
        cell.amountTextField.textColor = UIColor.gray
        cell.currencyLabel.textColor = UIColor.gray
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ExpenseDetailViewController{
            controller.split = self.split
            controller.expense = self.expense
            controller.newExpense = self.newExpense
        }
        
        if let controller = segue.destination as? DetailSplitViewController{
                controller.split = self.split
        }
        
        let senderButton = sender as! UIButton
        if senderButton == self.saveButton {
            if let expense =  self.expense {
                // UPDATE
                self.expense?.title = expenseNameTextField.text ?? ""
                self.expense?.date = Date.toDate(dateString: self.dateTextField.text ?? "")
                let total = (self.totalExpense.text! as NSString).floatValue
                self.expense?.totalAmount = total
                update(participates: self.participates!)
                
                Expense.modify(object: expense.dao)
            } else {
                // CREATE
                let total = (self.totalExpense.text! as NSString).floatValue
                self.newExpense = ExpenseModel(date: Date.toDate(dateString: self.dateTextField.text ?? ""), picture: self.imageExpense.image(for: .normal)!, title: expenseNameTextField.text ?? "", totalAmount: total, split: self.split)
                createParticipate(expense: newExpense!)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func update(participates: [ParticipateModel]) {
        let cellsPaidByTable = self.paidByTable.visibleCells as! Array<AddExpenseViewCell>
        let cellsPaidForTable = self.paidForTable.visibleCells as! Array<AddExpenseViewCell>
        
        let sizeListe = cellsPaidByTable.count
        for i in 0..<sizeListe {
            participates[i].paidFor = (cellsPaidForTable[i].amountTextField.text! as NSString).floatValue
            participates[i].paidBy = (cellsPaidByTable[i].amountTextField.text! as NSString).floatValue
        }
    }
    
    func createParticipate (expense: ExpenseModel) {
        let cellsPaidByTable = self.paidByTable.visibleCells as! Array<AddExpenseViewCell>
        let cellsPaidForTable = self.paidForTable.visibleCells as! Array<AddExpenseViewCell>
        
        let sizeListe = cellsPaidByTable.count
        for i in 0..<sizeListe {
            let paidForValue = (cellsPaidForTable[i].amountTextField.text! as NSString).floatValue
            let paidByValue = (cellsPaidByTable[i].amountTextField.text! as NSString).floatValue
            let userModel = cellsPaidByTable[i].user!
            ParticipateModel(paidFor: paidForValue, paidBy: paidByValue, expense: expense, user: userModel)
        }
    }
    
    // MARK - TextField Manager
    // Set the right pad (decimal number)
    
    var touchedPaidBy: Bool = false
    var touchedPaidFor: Bool = false
    @IBOutlet weak var totalExpense: UITextField!{
        // ADD TOOL BAR
        didSet {
            self.totalExpense.keyboardType = UIKeyboardType.decimalPad
            totalExpense?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    
    //Action quand on touche le Text field de la cellule des paid by
    @IBAction func cellTextFieldPaidByTouched(_ sender: UITextField) {
        self.touchedPaidBy = true
        sender.keyboardType = UIKeyboardType.decimalPad
        sender.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
    }
    
    //Action quand on touche le Text field de la cellule des paid for
    @IBAction func cellTextFieldPaidForTouched(_ sender: UITextField) {
        self.touchedPaidFor = true
        sender.keyboardType = UIKeyboardType.decimalPad
        sender.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
    }
    
    // When we click done, we need to calculate the total amounts again ( for all textfield )
    @objc func doneButtonTappedForMyNumericTextField() {
        computePaidBy()
        computePaidFor()
        manageSaveButton()
        totalExpense.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func manageSaveButton(){
        let totalPaidFor: Float = (self.paidForTotal.text! as NSString).floatValue
        let totalPaidBy: Float = (self.paidByTotal.text! as NSString).floatValue
        let totalAmount: Float = (self.totalExpense.text! as NSString).floatValue
        
        if  totalAmount == totalPaidBy && totalAmount == totalPaidFor {
            self.saveButton.isEnabled = true
            self.saveButton.setTitle("Save",for: .normal)
            self.saveButton.backgroundColor = UIColor(red: 2, green: 195, blue: 154)
        } else {
            self.saveButton.isEnabled = false
            self.saveButton.setTitle("Fix",for: .normal)
            self.saveButton.backgroundColor = UIColor.red
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK - Date Pickers
    //Replacing keyboard with a Date Picker
    
    @IBAction func dateTextFieldBeginEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        sender.inputAccessoryView = createToolBar()
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //Adding the top tool bar to the date picker
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your Date"
        let labelButton = UIBarButtonItem(customView:label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([todayButton,flexibleSpace,labelButton,flexibleSpace,doneButton], animated: true)
        return toolBar
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateTextField.text = dateFormatter.string(from: Date())
        dateTextField.resignFirstResponder()
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
    }
    
    //MARK - Photo Manager
    
    @IBAction func displayActionSheet(_ sender: Any) {
        let alert = UIAlertController(title: "Update your photo", message: "Please select an option", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        alert.addAction(UIAlertAction(title: "Take a new photo", style: .default , handler:{ (UIAlertAction)in
            self.presentUIImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default , handler:{ (UIAlertAction)in
            self.presentUIImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func presentUIImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        computePaidFor()
        computePaidBy()
    }
}

extension AddExpenseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) -> UIImage {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return UIImage(named: "placeholder")!
        }
        dismiss(animated: true, completion: nil)
        self.imageExpense.setImage(chosenImage, for: .normal)
        self.expense?.picture = chosenImage
        return chosenImage
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


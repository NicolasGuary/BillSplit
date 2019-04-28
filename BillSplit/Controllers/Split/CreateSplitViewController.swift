//
//  CreateSplitViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 26/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class CreateSplitViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var splitImage: UIImageView!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var splitNameTextField: UITextField!
    @IBOutlet weak var beginDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextView!
    @IBOutlet weak var saveSplit: UIButton!
    @IBOutlet weak var cancelSplit: UIButton!
    
    @IBOutlet weak var deleteSplitButton: UIButton!
    
    var split: SplitModel?
    var selectedSplit: SplitModel?
    var indexPath: IndexPath?
    
    //Template images to init Splits
    let locationImages = ["hawaiiResort","balibalo", "mountainExpedition", "scubaDiving"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.selectedSplit {
            // INIT UPDATE
            self.splitImage.image = split.picture
            self.currencyTextField.text = split.currency
            self.splitNameTextField.text = split.title
            self.beginDateTextField.text = Date.toString(date: split.departureDate)
            self.endDateTextField.text = Date.toString(date: split.endDate)
            self.descrTextField.text = split.descr
            if let users = self.selectedSplit?.getAllUsers() {
                self.users = users
            }
        } else {
            // INIT CREATE
            self.deleteSplitButton.isHidden = true
        }
        userTextField.setBottomBorder()
        createPickerView(textfield: currencyTextField)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderButton = sender as! UIButton
        if senderButton == self.saveSplit {
            //If there's not a current split we create it, otherwise we update the selected split
            if let split = self.selectedSplit {
                // UPDATE
                split.picture = self.splitImage.image ?? UIImage(named: "balibalo")!
                split.currency = self.currencyTextField.text ?? "€"
                split.departureDate = Date.toDate(dateString: beginDateTextField.text ?? "")
                split.endDate = Date.toDate(dateString: endDateTextField.text ?? "")
                split.title = self.splitNameTextField.text ?? "Split Name"
                split.descr = self.descrTextField.text ?? "default description"
                
                self.selectedSplit?.update()
            } else {
                // CREATE
                let image = locationImages[Int.random(in: 0 ... 3)]
                //We update the self.split object that we created when adding members
                //If it doesn't exist, we need to create it...
                if self.split == nil {
                    let dateDeb = Date.toDate(dateString: beginDateTextField.text ?? "") as NSDate
                    let dateFin = Date.toDate(dateString: endDateTextField.text ?? "") as NSDate
                    self.split = SplitModel(title: splitNameTextField.text ?? "", descr: descrTextField.text, picture: self.splitImage.image!, currency: currencyTextField.text ?? "", departureDate: dateDeb, endDate: dateFin)
                } else {
                    self.split!.currency = self.currencyTextField.text ?? "€"
                    self.split!.departureDate = Date.toDate(dateString: beginDateTextField.text ?? "")
                    self.split!.endDate = Date.toDate(dateString: endDateTextField.text ?? "")
                    self.split!.title = self.splitNameTextField.text ?? "Split Name"
                    self.split!.descr = self.descrTextField.text ?? "default description"
                    self.split!.picture = self.splitImage.image ?? UIImage(named:"balibalo")!
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteSplit(_ sender: UIButton) {
    }
    // MARK - ADD USER
    
    @IBOutlet weak var usersCollection: UICollectionView!
    
    var users: [UserModel] = []
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBAction func addUser(_ sender: Any) {
        //If the Split object is nil when trying to add, we create it
        if self.split == nil && self.selectedSplit == nil{
            self.split = SplitModel(title: "String", descr: "String", picture: UIImage(named: "balibalo")!, currency: "String", departureDate: Date() as NSDate, endDate: Date() as NSDate)
        }

        var newUser: UserModel
        if let selectedSplit = self.selectedSplit {
            newUser = UserModel(pseudo: self.userTextField.text ?? "Pseudo default", avatar: UIImage(named: "default_avatar")!, arrivalDate: Date.currentDate(), departureDate: Date(), split: selectedSplit)
        } else {
            newUser = UserModel(pseudo: self.userTextField.text ?? "Pseudo default", avatar:  UIImage(named: "default_avatar")!, arrivalDate: Date.currentDate(), departureDate: Date(), split: self.split!)
        }
        
        self.userTextField.text = ""
        self.users.append(newUser)
        usersCollection.reloadData()
    }
    
    @IBAction func removeUser(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.usersCollection)
        let indexPath = self.usersCollection.indexPathForItem(at: buttonPosition)
        
        guard let index = indexPath else {
            return
        }
        
        
        if let selectedSplit = self.selectedSplit {
             SplitModel.removeFromUsers(split: selectedSplit, user: users[index.row])
        } else {
             SplitModel.removeFromUsers(split: self.split!, user: users[index.row])
        }
        
        users[index.row].delete()
        
        
        self.users.remove(at: index.row)
        usersCollection.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMembersList", for: indexPath) as! MemberViewCell
        cell.user = self.users[indexPath.row]
        cell.memberName.text = users[indexPath.row].pseudo
        cell.memberPicture.image = UIImage(named: "default_avatar")
        cell.memberPicture.setRounded()
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // MARK - Initialize special element
    
    
    //MARK - Begin and End Date Pickers
    //Replacing keyboard with a Date Picker
    @IBAction func beginDateFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.beginDatePickerValueChanged), for: UIControlEvents.valueChanged)
        sender.inputAccessoryView = createBeginToolBar()
    }

    @objc func beginDatePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        beginDateTextField.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func beginEndDateFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
        sender.inputAccessoryView = createEndToolBar()
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        endDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //Adding the top tool bar to the date picker
    func createBeginToolBar() -> UIToolbar {
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
        beginDateTextField.text = dateFormatter.string(from: Date())
        beginDateTextField.resignFirstResponder()
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        beginDateTextField.resignFirstResponder()
    }
    
    func createEndToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayEndButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEndButtonPressed(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your Date"
        let labelButton = UIBarButtonItem(customView:label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([todayButton,flexibleSpace,labelButton,flexibleSpace,doneButton], animated: true)
        return toolBar
    }
    
    @objc func todayEndButtonPressed(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        endDateTextField.text = dateFormatter.string(from: Date())
        endDateTextField.resignFirstResponder()
    }
    
    @objc func doneEndButtonPressed(sender: UIBarButtonItem) {
        endDateTextField.resignFirstResponder()
    }
    
    
    // MARK - Picker View Methods
    func createPickerView(textfield: UITextField){
        let thePicker = UIPickerView()
        currencyTextField.inputView = thePicker
        thePicker.delegate = self
        currencyTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
    }
    @objc func doneButtonTappedForMyNumericTextField() {
        currencyTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    let myPickerData = [String](arrayLiteral: "$", "€", "£", "CHF", "IDR", "YEN")
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = myPickerData[row]
    }
    
    
    //MARK - Photo Manager
    
    @IBAction func displayImagePicker(_ sender: Any) {
        
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
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentUIImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    
}

extension CreateSplitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) -> UIImage {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return UIImage(named: "balibalo")!
        }
        dismiss(animated: true, completion: nil)
        self.splitImage.image = chosenImage
        self.split?.picture = chosenImage
        return chosenImage
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

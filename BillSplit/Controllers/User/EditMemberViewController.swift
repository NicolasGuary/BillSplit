//
//  EditMemberViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 01/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class EditMemberViewController: UIViewController, UITextFieldDelegate {
    var user: UserModel!
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userPseudo: UITextField!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userAvatar.setRounded()
        self.userPseudo.text = user.pseudo
        self.userAvatar.image = user.avatar
        self.userPseudo.setBottomBorder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderButton = sender as! UIButton
        if senderButton == self.save {
            user.pseudo = self.userPseudo.text ?? ""
            user.avatar = self.userAvatar.image ?? UIImage(named: "default_avatar")!
            User.modify(object: user.dao)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    
}

extension EditMemberViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) -> UIImage {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return UIImage(named: "default_avatar")!
        }
        dismiss(animated: true, completion: nil)
        self.userAvatar.image = chosenImage
        return chosenImage
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

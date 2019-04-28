//
//  ProfileViewController.swift
//  cardLayout
//
//  Created by Nicolas Guary on 20/03/2019.
//  Copyright © 2019 Riley Norris. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var pseudoUser: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    @IBOutlet weak var barChart: BarChart!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: UserModel?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFieldView()
        
    }
    
    func initFieldView() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.layer.borderColor = UIColor.init(red: 241, green: 245, blue: 244).cgColor
        if let user = self.user{
            self.joinDate.text = Date.toString(date: user.arrivalDate)
            self.pseudoUser.text = user.pseudo
            self.profileImageView.image = user.avatar
        }
        let dataEntries = generateDataEntries()
        barChart.dataEntries = dataEntries
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditMemberViewController {
            controller.user = self.user
        }
    }

    @IBAction func unwindFromEditUser(sender: UIStoryboardSegue){
        if let controller = sender.source as? EditMemberViewController{
            if sender.identifier == "saveEditUserSegue" {
                if let newUser = controller.user {
                    self.user = newUser
                    User.save()
                    initFieldView()
                }
            }
        }
    }
    
    
    
    
    //MARK - Chart Methods
    //Get Data for the chart
    func generateDataEntries() -> [BarEntry] {
        var result: [BarEntry] = []
        var paidByTotal = Float(0)
        var paidForTotal = Float(0)
        if let participates = self.user?.participates{
            for p in participates{
               paidByTotal += p.paidBy
               paidForTotal += p.paidFor
            }
            
        }
        
    var heightPaidBy = Float(0)
    var heightPaidFor = Float(0)
    let maximum = max(paidForTotal, paidByTotal)
        if maximum > 0 {
            heightPaidBy = Float((paidByTotal / maximum))
            heightPaidFor = Float((paidForTotal / maximum))
        }
   
    //Paid By Value
    result.append(BarEntry(color: UIColor(red: 2, green: 195, blue: 154), height: heightPaidBy, textValue: "\(paidByTotal)", title: "Sent"))
    //Paid For Value
    result.append(BarEntry(color:  UIColor(red: 193, green: 8, blue: 1), height: heightPaidFor, textValue: "\(paidForTotal)", title: "Received"))
    return result
    }
}

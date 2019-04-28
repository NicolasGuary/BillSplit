//
//  BalanceViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 01/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BalanceViewController : UIViewController, UICollectionViewDataSource, hasSplitProtocol {
    
    var split: SplitModel?
    @IBOutlet weak var balanceChart: BasicBarChart!
    @IBOutlet weak var balanceCollectionView: UICollectionView!
    
    var participate: [String : Float]?
    var exchanges:[[String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataEntries = generateDataEntries()
        balanceChart.dataEntries = dataEntries
        self.participate = self.fetchParticipate()
        self.exchanges = self.computeExchanges()
        balanceChart.reloadInputViews()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let exchanges = self.exchanges{
            return exchanges.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBalance", for: indexPath) as! BalanceViewCell
        if let exchangesSelected = self.exchanges{
            let exchange = exchangesSelected[indexPath.row]
            cell.firstUserAvatar.image = UIImage(named: "default_avatar")
            cell.secondUserAvatar.image = UIImage(named: "default_avatar")
            cell.amount.text = exchange[2]
            cell.currencyLabel.text = self.split?.currency
            cell.firstUserName.text = exchange[1]
            cell.secondUserName.text = exchange[0]
        }
         return cell
    }
    
    
    // MARK - Egalize Expenses between users
    // Fill of tab of 2 name of user. The first is remboursed by the second, the third is the amount
    func computeExchanges () -> [[String]]{
        var trans: [[String]] = []
        if var p = self.participate {
            while hasDebts(participates: p) {
                let maxUser: String = self.maxUser(participates: p)
                while p[maxUser]! > 0 {
                    let minUser: String = self.minUser(participates: p)
                    var amount: String
                    if abs(p[maxUser]!) <= abs(p[minUser]!) {
                        amount = String(p[maxUser]!)
                        p[minUser]! = ((p[maxUser]!+p[minUser]!)*100).rounded() / 100
                        p[maxUser]! = 0
                    } else {
                        amount = String(abs(p[minUser]!))
                        p[maxUser]! = ((p[maxUser]!+p[minUser]!)*100).rounded() / 100
                        p[minUser]! = 0
                    }
                    trans.append([maxUser, minUser, amount])
                }
            }
        }
        return trans
    }
    
    func hasDebts(participates: [String : Float]) -> Bool {
        var quit = false
        for (_, value) in participates  {
            if value != Float(0){
                quit = true
            }
        }
        return quit
    }
    
    func minUser(participates: [String : Float]) -> String{
        
        // Pre-requies : there is a name with a negative value
        var minName: String = ""
        var minValue: Float = 0
        for (name, value) in participates  {
            if value < minValue && value < 0 {
                minName = name
                minValue = value
            }
        }
        return minName
    }
    
    func maxUser(participates: [String : Float]) -> String {
        // Pre-requies : there is a name with a positive value
        var maxName: String = ""
        var maxValue: Float = 0
        for (name, value) in participates  {
            if value > maxValue && value > 0 {
                maxName = name
                maxValue = value
            }
        }
        return maxName
    }
    
    
    // Fetch en compute participate of each users
    func fetchParticipate() -> [String : Float] {
        var values = [String : Float]()
        if let users = self.split?.getAllUsers(){
            for user in users {
                var paidByTotal = Float(0)
                var paidForTotal = Float(0)
                if let participates = user.participates{
                    for p in participates{
                        paidByTotal += p.paidBy
                        paidForTotal += p.paidFor
                    }
                    let amount = paidForTotal - paidByTotal
                    values[user.pseudo] = ((-amount)*100).rounded() / 100
                }
            }
        }
        
        return values
    }
    
    
    // MARK - Balance Data Manager
    func generateDataEntries() -> [BarEntry] {
        var result: [BarEntry] = []
        guard let participates = self.participate else { return [] }
 
        if (self.split?.getAllUsers()) != nil {
            var max = participates.values.max()
            if max == 0 { max = 1 }
            for (name, value) in participates  {
                let height: Float = Float((value*0.7 / max!))
                if value < 0 {
                    result.append(BarEntry(color: UIColor(red: 193, green: 8, blue: 1), height: height, textValue: "\(value)", title: name))
                } else if value > 0{
                     result.append(BarEntry(color: UIColor(red: 2, green: 195, blue: 154), height: height, textValue: "\(value)", title: name))
                }
            }
        }
        return result
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.participate = self.fetchParticipate()
        let dataEntries = generateDataEntries()
        balanceChart.dataEntries = dataEntries
        self.exchanges = self.computeExchanges()
        self.balanceCollectionView.reloadData()
        balanceChart.reloadInputViews()


    }
}

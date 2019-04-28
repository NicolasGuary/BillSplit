//
//  DetailSplitViewController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 26/03/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import Foundation
import UIKit

class DetailSplitViewController : UIViewController {
    
    
    @IBOutlet weak var splitImage: UIImageView!
    @IBOutlet weak var splitDescription: UILabel!
    
    @IBOutlet weak var splitName: UILabel!
    var split: SplitModel?
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var newExpenseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitName.text = split?.title
        self.splitImage.image = split?.picture
        self.splitDescription.text = split?.descr
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSplitSegue" {
            if let controller = segue.destination as? CreateSplitViewController{
                controller.selectedSplit = self.split
                controller.indexPath = self.indexPath
            }
        }
        
        if let controller = segue.destination as? CustomTopTabBarController{
                controller.split = self.split
        }
        
        if let controller = segue.destination as? AddExpenseViewController{
            controller.split = self.split
        }
    }
}

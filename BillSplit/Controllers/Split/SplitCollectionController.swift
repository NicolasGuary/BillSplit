//
//  SplitCollectionController.swift
//  BillSplit
//
//  Created by Nicolas Guary on 01/04/2019.
//  Copyright © 2019 Nicolas Guary. All rights reserved.
//

import UIKit

class SplitCollectionController: NSObject, UICollectionViewDataSource, SplitSetViewModelDelegate {
    
    var splitSetViewModel: SplitSetViewModel
    var collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        if let splitModels = SplitModel.fetchAllSplits()  {
            self.splitSetViewModel = SplitSetViewModel(data: splitModels)
        } else {
            self.splitSetViewModel = SplitSetViewModel(data: [] )
        }
        
        super.init()
        self.collectionView.dataSource = self
        self.splitSetViewModel.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.splitSetViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if let split = self.splitSetViewModel.get(splitAt: indexPath.row) {
            cell.locationImage.image = split.picture
            cell.locationName.text = split.title
            cell.locationDescription.text = split.descr
            cell.split = split
        }
        
        CellStyle.customizeCell(cell: cell)
        return cell
    }
    
    
    /// called when set globally changes
    func dataSetChanged() {
        self.collectionView.reloadData()
    }
}

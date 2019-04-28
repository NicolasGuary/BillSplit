import UIKit
import CoreData
class ViewController: UIViewController {
    var splitCollectionController: SplitCollectionController?
    
    @IBOutlet weak var splitCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitCollectionController = SplitCollectionController(collectionView: self.splitCollection)
        
    }
    
    
    @IBAction func unwindToViewSplit(sender: UIStoryboardSegue){
        if let controller = sender.source as? CreateSplitViewController{

            if sender.identifier == "saveSplitSegue" {
                if let newSplit = controller.split {
                    self.splitCollectionController?.splitSetViewModel.add(split: newSplit)
                }
            }
            
            if sender.identifier == "deleteSplitSegue" {
                if let index = controller.indexPath {
                    self.splitCollectionController?.splitSetViewModel.delete(at: index)
                }
            }
        }
        

        self.splitCollection.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailSplitViewController{
            if let cell = sender as? CollectionViewCell {
                controller.split = cell.split
                controller.indexPath = self.splitCollection.indexPath(for: cell)
            }
        }
    }
}


import UIKit
import CoreData

class MembersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, hasSplitProtocol {
    
    @IBOutlet weak var membersList: UICollectionView!

    var users: [UserModel] = []
    var split: SplitModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let users = self.split?.getAllUsers() {
            self.users = users
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMember", for: indexPath) as! MemberViewCell
        
        cell.memberPicture.image = users[indexPath.row].avatar
        cell.memberPicture.setRounded()
        cell.memberName.text = users[indexPath.row].pseudo
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserProfile" {
            if let controller = segue.destination as? ProfileViewController{
                if let cell = sender as? MemberViewCell {
                    if let indexPath = self.membersList.indexPath(for: cell){
                        controller.user = self.users[indexPath.row]
                        controller.indexPath = indexPath
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let users = self.split?.getAllUsers() {
            self.users = users
        }
        self.membersList.reloadData()
    }
}


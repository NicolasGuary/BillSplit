import UIKit

class CustomTopTabBarController: UITabBarController {
    var split: SplitModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let children = self.childViewControllers
        for child in children {
            if var c = child as? hasSplitProtocol {
                 c.split = self.split
            }
        }
        
       customizeBar()
    }
    
    
    //Change top navbar text styles
    func customizeBar(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 2, green: 195, blue: 154), NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20.0, weight: .regular) as Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 2, green: 195, blue: 154),NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20.0, weight: .regular) as Any], for: .selected)
    }
    
    override func viewDidLayoutSubviews() {
        //move navbar to top
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: (tabBar.frame.size.height - 8.0))
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(red: 2, green: 195, blue: 154), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 1.0)
        super.viewDidLayoutSubviews()
    }
    
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


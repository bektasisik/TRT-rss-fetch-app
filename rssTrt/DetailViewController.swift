import Foundation
import UIKit

class DetailViewController: UIViewController {
  
    var headTitle = ""
    var desc = ""
    var image = ""
    var link = ""

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = self.headTitle
        lblDesc.text = self.desc
        
        viewImage.load(urlString: self.image)
        
    }
    
    @IBAction func openUrlBtn(_ sender: Any) {
        let url = URL(string:self.link)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

extension UIImageView{
    func load(urlString : String) {
        
        guard let url = URL(string : urlString) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

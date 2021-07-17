import UIKit

class NewsViewController: UIViewController,XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tblView: UITableView!
    
    var rssUrlAddress:String = "http://www.trt.net.tr/rss/gundem.rss"
    var parser = XMLParser()

    var titles: [String] = []
    var descs: [String] = []
    var images: [String] = []
    var links: [String] = []

    var tag = NSString()
    
    var title1 = NSMutableString()
    var desc = NSMutableString()
    var image = NSMutableString()
    var link = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataFromUrl(rssUrlString: self.rssUrlAddress)
    }
    
    func dataFromUrl(rssUrlString: String) {
        
        titles =  []
        descs = []
        images = []
        links = []

        parser = XMLParser(contentsOf: URL(string: rssUrlString )! )!
        parser.delegate = self
        let success = parser.parse()
        if(success) {
            tblView.reloadData()
        } else {
            print("xml verisi yok")
        }
    }
    
    // XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        tag = elementName as NSString
        if(elementName as NSString) .isEqual(to: "item") {
            title1 = ""
            desc = ""
            image = ""
            link = ""
        }
        if(attributeDict.count > 0 && elementName == "enclosure"){
            if(attributeDict["type"] == "image/jpeg") {
                let imgUrl = attributeDict["url"]
                image.append(imgUrl ?? "")
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(tag.isEqual(to: "title")) {
            title1.append(string)
        }
        if(tag.isEqual(to: "description")) {
            desc.append(string)
        }
        if(tag.isEqual(to: "link")) {
            link.append(string)
        }
        /*if(tag.isEqual(to: "enclosure")) {
         image.append(string)
         }*/
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if( elementName as NSString ).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                titles.append(title1 as String)
            }
            if !desc.isEqual(nil) {
                descs.append(desc as String)
            }
            if !image.isEqual(nil) {
                images.append(image as String)
            }
            if !link.isEqual(nil) {
                links.append(link as String)
            }
        }
    }
    

    // UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tblView.dequeueReusableCell(withIdentifier: "baslik") as! UITableViewCell
        cell.textLabel?.text = self.titles[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.headTitle = self.titles[indexPath.row]
        vc?.desc = self.descs[indexPath.row]
        vc?.image = self.images[indexPath.row]
        vc?.link = self.links[indexPath.row]
        navigationController?.pushViewController( vc! , animated: true)
    }
}

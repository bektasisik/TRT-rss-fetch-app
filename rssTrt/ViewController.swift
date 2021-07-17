import UIKit

class ViewController: UIViewController,XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var inputRssUrl: UITextField!
    @IBOutlet weak var inputRssTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var rssItems: [RssModel] = []
    var fm = FileManager.default
    var mainUrl: URL? = Bundle.main.url(forResource: "rssdata", withExtension: "json")

    override func viewDidLoad() {
        super.viewDidLoad()
        inputRssUrl.text = ""
        inputRssTitle.text = ""
        loadData()
    }
    
    func loadData() {
        guard let mainUrl = Bundle.main.url(forResource: "rssdata", withExtension: "json") else { return }
        do {
            let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let subUrl = documentDirectory.appendingPathComponent("rssdata.json")
            loadFile(mainPath: mainUrl, subPath: subUrl)
        } catch {
            print(error)
        }
    }

    func loadFile(mainPath: URL, subPath: URL){
        if fm.fileExists(atPath: subPath.path){
            decodeData(pathName: subPath)
            
            if rssItems.isEmpty{
                decodeData(pathName: mainPath)
            }
            
        }else{
            decodeData(pathName: mainPath)
        }
        
        self.tableView.reloadData()
    }
    
    func decodeData(pathName: URL){
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            rssItems = try decoder.decode([RssModel].self, from: jsonData)
        } catch {}
    }
    
    
    /*
    func writeToFile() {
        let jsonString = json(from: rssItems)

        if let jsonData = jsonString,
            let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("rssdata.json")
            do {
                try jsonData.write(to: pathWithFileName, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                // handle error
            }
        }
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    */
    
    @IBAction func btnAddTable(_ sender: Any) {
        if( inputRssUrl.text != "" ) {
            var rss = RssModel();
            rss.url = inputRssUrl.text
            rss.title = inputRssTitle.text
            rssItems.append(rss)
            inputRssUrl.text = ""
            inputRssTitle.text = ""
            //
            
            // writeToFile()
            // loadData()
 
            //
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "rss") as! UITableViewCell
        cell.textLabel?.text = self.rssItems[indexPath.row].title
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController
        vc?.rssUrlAddress = self.rssItems[indexPath.row].url ?? "http://www.trt.net.tr/rss/gundem.rss"
        navigationController?.pushViewController( vc! , animated: true)
    }

    func writeJsonData() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return}
        let fileUrl = url.appendingPathComponent("rssdata.json")
        
    }
}

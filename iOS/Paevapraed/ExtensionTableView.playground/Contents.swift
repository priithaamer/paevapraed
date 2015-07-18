import UIKit
import XCPlayground

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    let items = ["Hello 1", "Hello 2", "Hello 3", "Hello 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: 640, height: 750)
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.tableView)
        
        let cn = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        
        self.view.addConstraint(cn)
        
        self.view.layoutIfNeeded()
        
        NSLog("Yolo")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(self.items[indexPath.row])"
        
        return cell
    }
}

XCPShowView("Playground VC", view: ViewController().view)

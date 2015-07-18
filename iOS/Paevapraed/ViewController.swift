//
//  ViewController.swift
//  Paevapraed
//
//  Created by Priit Haamer on 23.05.15.
//  Copyright (c) 2015 Priit Haamer. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var objects = ["Foo", "Bar"]
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.table.estimatedRowHeight = 30
        self.table.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow! {
//                let object = objects[indexPath.row]
//                (segue.destinationViewController as! DetailViewController).detailItem = object
//            }
//        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestoCell", forIndexPath: indexPath) as! RestoTableViewCell
        
        cell.nimiLabel!.text = objects[indexPath.row]
        
        for i in 1...3 {
            let label = UILabel()
            label.text = "\(objects[indexPath.row]) - \(i)"
            
            cell.offersStack.addArrangedSubview(label)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}


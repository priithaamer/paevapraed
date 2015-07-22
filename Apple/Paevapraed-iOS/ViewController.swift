//
//  ViewController.swift
//  Paevapraed
//
//  Created by Priit Haamer on 23.05.15.
//  Copyright (c) 2015 Priit Haamer. All rights reserved.
//

import UIKit
import Paevapraed

class ViewController: UITableViewController {
    
    var restaurants = [Restaurant]()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.table.estimatedRowHeight = 30
        self.table.rowHeight = UITableViewAutomaticDimension
        
        Today.fetch {
            self.restaurants = $0.restaurants
            
            self.table.reloadData()
        }
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
        return self.restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestoCell", forIndexPath: indexPath) as! RestoTableViewCell
        
        let restaurant = self.restaurants[indexPath.row]
        
        cell.nimiLabel!.text = restaurant.name
        
        for offer in restaurant.offers {
            let label = UILabel()
            label.text = offer.name
            
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


//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Priit Haamer on 24.05.15.
//  Copyright (c) 2015 Priit Haamer. All rights reserved.
//

// https://blog.fynydd.com/tips-for-building-an-ios-notification-center-today-extension/ Palju kasulikke nippe widgeti tegemisel

import UIKit
import NotificationCenter
import Paevapraed

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    var restaurants = [Restaurant]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("today view did load")
        
        // Do any additional setup after loading the view from its nib.
        
//        self.tableView!.estimatedRowHeight = 30
//        self.tableView!.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
    //            return UIEdgeInsetsZero
    //    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: (NCUpdateResult) -> Void) {
        NSLog("widget perform update")
        
        Today.fetch() {
            
            self.restaurants = $0.restaurants
            
//            self.tableView!.reloadData()
//            self.preferredContentSize = self.tableView!.contentSize
            
            completionHandler(.NewData)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RestaurantView
        
        cell.nameLabel?.text = "\(self.restaurants[indexPath.row].name)"
        
        for i in 1...3 {
            let label = UILabel()
            label.text = "\(self.restaurants[indexPath.row].name) - \(i)"
            cell.offersStack.addArrangedSubview(label)
        }
        
        return cell
    }
}

//
//  DetailViewController.swift
//  Paevapraed
//
//  Created by Priit Haamer on 24.05.15.
//  Copyright (c) 2015 Priit Haamer. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var nimiLabel: UILabel!
    
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: String = self.detailItem {
            if let label = self.nimiLabel {
                label.text = detail
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

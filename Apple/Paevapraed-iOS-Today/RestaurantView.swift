//
//  RestaurantView.swift
//  Paevapraed
//
//  Created by Priit Haamer on 15.07.15.
//  Copyright © 2015 Priit Haamer. All rights reserved.
//

import UIKit

@IBDesignable class RestaurantView: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var offersStack: UIStackView!
    
    func viewDidLoad() {
        print("RestaurantView did load")
    }
}
//
//  Offer.swift
//  Paevapraed
//
//  Created by Priit Haamer on 15.07.15.
//  Copyright © 2015 Priit Haamer. All rights reserved.
//

import Foundation

public class Offer {
    
    public var name: String
    
    public var description: String
    
    public var price: Double
    
    init(name: String, description: String, price: Double) {
        self.name = name
        self.description = description
        self.price = price
    }
    
}

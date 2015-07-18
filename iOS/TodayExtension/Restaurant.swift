//
//  Restaurant.swift
//  Paevapraed
//
//  Created by Priit Haamer on 15.07.15.
//  Copyright © 2015 Priit Haamer. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Restaurant {
    
    public var name: String
    
    public var code: String
    
    public var offers: [Offer]
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
        self.offers = []
    }
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.code = json["code"].stringValue
        self.offers = []
    }
    
    public func addOffer(offer: Offer) {
        self.offers.append(offer);
    }
}
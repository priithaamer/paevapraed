//
//  Today.swift
//  Paevapraed
//
//  Created by Priit Haamer on 15.07.15.
//  Copyright © 2015 Priit Haamer. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Today {
    
    public var restaurants: [Restaurant]
    
    init(data: JSON) {
        self.restaurants = []
        
        for (index: _, subJson: json) in data["restaurants"] {
            restaurants.append(Restaurant(json: json))
        }
    }
    
    public static func fetch(callback: (Today) -> Void) {
        
        NSLog("Today.fetch")
        
        let url = "http://imac.local:9090/api/v1/tartu/today.json"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Paevapraed Today Extension", forHTTPHeaderField: "User-Agent")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if (error != nil) {
                NSLog("NSURLSESSION ERROR ERROR")
                // TODO: Handle error
                // callback("", error.localizedDescription)
            } else {
                callback(Today(data: JSON(data: data!)))
            }
        }
        
        task.resume()
        
    }
    
}
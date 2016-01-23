//
//  API.swift
//  Talk2Cook
//
//  Created by David Keller on 22.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

class API: NSObject {
    
    class var appId: String? {
        get {
            guard let path = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist"), let configuration = NSDictionary(contentsOfFile: path) else { return nil }
            
            return configuration["Yummly"]?["app id"] as? String
        }
    }
    
    class var appKey: String? {
        get {
            guard let path = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist"), let configuration = NSDictionary(contentsOfFile: path) else { return nil }
            
            return configuration["Yummly"]?["app key"] as? String
        }
    }
    

}

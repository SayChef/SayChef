//
//  API.swift
//  Talk2Cook
//
//  Created by David Keller on 22.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit
import Alamofire

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
    


    class func search(string: String, handler: [Recipe]? -> ()) {
        guard let appId = self.appId, let appKey = self.appKey else { return }
        Alamofire.request(.GET, "https://api.yummly.com/v1/api/recipes", parameters: ["_app_id": appId, "_app_key": appKey, "q": string])
            .validate()
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                var recipes: [Recipe]?
                
                if let JSON = response.result.value {
                    let matches = JSON["matches"] as! [AnyObject]
                    
                    recipes = []
                    
                    for match in matches {
                        if let name = match["recipeName"] as? String, let identifier = match["id"] as? String {
                            let recipe = Recipe(identifier: identifier, name: name)
                            recipes?.append(recipe)
                        }
                    }
                }
                
                handler(recipes)
        }
    }
    
}

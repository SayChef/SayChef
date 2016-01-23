//
//  Recipe.swift
//  Talk2Cook
//
//  Created by David Keller on 23.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

struct Recipe {
    
    init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
    
    // Search result content
    let identifier: String
    let name: String
    
    // Recipe details
    var didLoadFullRecipe = false
    var image: NSURL? = nil
}
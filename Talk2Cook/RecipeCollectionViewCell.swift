//
//  RecipeCollectionViewCell.swift
//  Talk2Cook
//
//  Created by David Keller on 23.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit
import AlamofireImage

class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var recipe: Recipe {
        get {
            return self.recipe
        }
        set {
            self.name.text = newValue.name
            self.image.sizeToFit()
            API.loadRecipe(newValue, handler: fullRecipe)
        }
    }
    
    func fullRecipe(recipe: Recipe) {
        if let imageURL = recipe.imageUrl {
            image.af_setImageWithURL(NSURL(string: imageURL)!)
        }
    }
    
    override func prepareForReuse() {
        image.af_cancelImageRequest()
        image.image = nil
        name.text = nil
    }
    
}

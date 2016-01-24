//
//  MasterViewController.swift
//  Talk2Cook
//
//  Created by David Keller on 22.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

class SearchResultsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var detailViewController: RecipeViewController? = nil
    var recipes = [Recipe]()
    var query: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let query = query {
            API.search(query, handler: { (recipes: [Recipe]?) -> () in
                if let recipes = recipes {
                    self.recipes = recipes
                    self.collectionView?.reloadData()
                }
            })
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                let recipe = recipes[indexPath.row]
                let controller = segue.destinationViewController as! RecipeViewController
                controller.detailItem = recipe
            }
        }
    }

    
    // MARK: - Collection view
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeCollectionViewCell
        
        let recipe = recipes[indexPath.item]
        cell.recipe = recipe
        
        return cell
    }
    
    // MARK: - Collection view Delegate Layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size
        return CGSize(width: (screenSize.width / 2), height: (screenSize.height / 3))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

}


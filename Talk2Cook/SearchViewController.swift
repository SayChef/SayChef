//
//  SearchViewController.swift
//  Talk2Cook
//
//  Created by Dave on 23.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSearchResults" {
            let controller = segue.destinationViewController as! MasterViewController
            controller.query = searchField.text
            searchField.text = nil
        }
    }

}

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
    @IBOutlet weak var microphoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchField.text = nil
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "updateState", name: HoundVoiceSearchStateChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: "hotPhrase", name: HoundVoiceSearchHotPhraseNotification, object: nil)
        
        HoundVoiceSearch.instance().startListeningWithCompletionHandler {
            error in
            dispatch_async(dispatch_get_main_queue()) {
//                self.microphoneButton.selected = true
                
                if let error = error {
                    self.searchField.placeholder = error.localizedDescription
                }
            }
        }
        
        updateState()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        HoundVoiceSearch.instance().stopListeningWithCompletionHandler {
            error in
            dispatch_async(dispatch_get_main_queue()) {
//                self.microphoneButton.selected = false
                
                if let error = error {
                    self.searchField.placeholder = error.localizedDescription
                }
            }
        }
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
            let controller = segue.destinationViewController as! SearchResultsViewController
            controller.query = searchField.text
            searchField.text = nil
        }
    }

    // MARK: - HoundSDK
    
    let voiceSearchEndPoint = "https://api.houndify.com/v1/audio"
    
    func startSearch() {
        self.searchField.text = nil
        
        HoundVoiceSearch.instance().startSearchWithRequestInfo(nil, endPointURL: NSURL(string: voiceSearchEndPoint)) {
            error, responseType, response, dictionary in
            
            dispatch_async(dispatch_get_main_queue()) {
                if let error = error {
                    self.searchField.placeholder = error.localizedDescription
                } else {
                    if responseType == .PartialTranscription {
                        // Handle partial transcription
                        
                        let partialTranscript = response as? HoundDataPartialTranscript
                        
                        self.searchField.text = partialTranscript?.partialTranscript
                    } else if responseType == .HoundServer {
                        // JSON is in `dictionary`
                        
                        let houndServer = response as? HoundDataHoundServer
                        let commandResult = houndServer?.allResults.firstObject()
                        let nativeData = commandResult?["NativeData"]
                        
                        print("NativeData: \(nativeData)")
                        
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let searchViewController = mainStoryboard.instantiateViewControllerWithIdentifier("searchResults") as! SearchResultsViewController
                        searchViewController.query = "apple pie"
                        self.navigationController?.pushViewController(searchViewController, animated: true)
                    }
                }
            }
        }
    }
    
    func updateState() {
        switch HoundVoiceSearch.instance().state {
        case .None:
            self.microphoneButton.selected = false
            self.searchField.placeholder = "Not Ready"
        case .Ready:
            self.microphoneButton.selected = false
            self.searchField.placeholder = "Say 'OK Hound'"
        case .Recording:
            self.microphoneButton.selected = true
            self.searchField.placeholder = "Recording"
        case .Searching:
            self.microphoneButton.selected = true
            self.searchField.placeholder = "Searching"
        case .Speaking:
            self.microphoneButton.selected = true
            self.searchField.placeholder = "Speaking"
        }
    }
    
    func hotPhrase() {
        self.startSearch()
    }
    
    
}

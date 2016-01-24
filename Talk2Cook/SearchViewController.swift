//
//  SearchViewController.swift
//  Talk2Cook
//
//  Created by Dave on 23.01.16.
//  Copyright © 2016 PennApps XIII. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    //@interface VoiceSearchViewController()<UISearchBarDelegate>
    //**HOW DO I DO THIS?!
    
    //@property(nonatomic, strong) IBOutlet UIButton* searchButton;
    @IBOutlet weak var searchButton: UIButton!
    
    //@property(nonatomic, strong) IBOutlet UITextView* textView;
    @IBOutlet weak var textView: UITextView!
    
    //REMOVED @property(nonatomic, strong) IBOutlet UISearchBar* searchBar;
    
    //REMOVED @property(nonatomic, strong) UIView* levelView;
    
    
    //IGNORE
    //@property(nonatomic, strong) IBOutlet UIButton* listeningButton; //Always listening, means NOT USING THIS BUTTON

    
    let VOICE_SEARCH_END_POINT = "https://api.houndify.com/v1/audio"
    
    //View Did Load Code to translate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "updateState", name: HoundVoiceSearchStateChangeNotification, object: nil)
//        notificationCenter.addObserver(self, selector: "audioLevel", name: HoundVoiceSearchAudioLevelNotification, object: nil)
        notificationCenter.addObserver(self, selector: "hotPhrase", name: HoundVoiceSearchHotPhraseNotification, object: nil)
        
        updateState()
        
        HoundVoiceSearch.instance().startListeningWithCompletionHandler {
            error in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    self.textView.text = error.localizedDescription
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        HoundVoiceSearch.instance().stopListeningWithCompletionHandler {
            error in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    self.textView.text = error.localizedDescription
                }
            }
        }
    }
    
    func startSearch() {
        textView.text = nil
        let requestInfo: [String: String] = [ :
            // additional parameters to create a dictionary
        ]
        
        let endPointURL = NSURL(string:VOICE_SEARCH_END_POINT)
        
        //Start voice search
        
        HoundVoiceSearch.instance().startSearchWithRequestInfo(requestInfo, endPointURL: endPointURL) {
            error, responseType, response, dictionary in
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil){
                        print(error.localizedDescription)
                        self.textView.text = error.localizedDescription
                } else {
                    if (responseType == .PartialTranscription) {
                        //handle partial transcription
                        let partialTranscript = response as! HoundDataPartialTranscript
                        self.textView.text = partialTranscript.partialTranscript
                    } else if (responseType == .HoundServer) {
                        //Display response JSON
                        self.textView.text = "JSON WOULD GO HERE"
                        
                        let houndServer = response as? HoundDataHoundServer
                        let commandResult = houndServer?.allResults.firstObject()
                        let nativeData = commandResult?["NativeData"]
                        
                        print("NativeData: \(nativeData)")
                    }
                }
            }
        }
    }
    
        
    func updateState() {
        switch HoundVoiceSearch.instance().state {
        case .None:
            self.status.text = "Not Ready"
            self.searchButton.userInteractionEnabled = false
            self.searchButton.setTitle("", forState: .Normal)
            self.searchButton.hidden = true
        case .Ready:
            self.status.text = "Ready"
            self.searchButton.userInteractionEnabled = true
            self.searchButton.setTitle("Search", forState: .Normal)
            self.searchButton.backgroundColor = self.view.tintColor
            self.searchButton.hidden = false
        case .Recording:
            self.status.text = "Recording"
            self.searchButton.userInteractionEnabled = true
            self.searchButton.setTitle("Stop", forState: .Normal)
            self.searchButton.backgroundColor = self.view.tintColor;
            self.searchButton.hidden = false
        case .Searching:
            self.status.text = "Searching"
            self.searchButton.userInteractionEnabled = true
            self.searchButton.setTitle("Stop", forState: .Normal)
            self.searchButton.backgroundColor = self.view.tintColor
            self.searchButton.hidden = false
        case .Speaking:
            self.status.text = "Speaking"
            self.searchButton.userInteractionEnabled = true
            self.searchButton.setTitle("Stop", forState: .Normal)
            self.searchButton.backgroundColor = UIColor.redColor();
            self.searchButton.hidden = false
        }
    }
    
    func audioLevel(notification: NSNotification) {
        // Display current audio level
        //let audioLevel = notification.object?.floatValue
        
        // Maybe
    }

    func hotPhrase() {
        self.startSearch()
    }
    
    @IBAction func searchButtonTapped() {
        switch HoundVoiceSearch.instance().state {
        case .None: break
        case .Ready:
            self.startSearch()
        case .Recording:
            HoundVoiceSearch.instance().stopSearch()
        case .Searching:
            HoundVoiceSearch.instance().cancelSearch()
        case .Speaking:
            HoundVoiceSearch.instance().stopSpeaking()
        }
    }
    
    
         /*~~~~~~~~~~~~~~~TRANSLATING CODE~~~~~~~~~~~~~~~~~~~~
    
    

    else
    {
    if (responseType == HoundVoiceSearchResponseTypePartialTranscription)
    {
    // Handle partial transcription
    
    HoundDataPartialTranscript* partialTranscript = (HoundDataPartialTranscript*)response;
    
    self.textView.text = partialTranscript.partialTranscript;
    }
    else if (responseType == HoundVoiceSearchResponseTypeHoundServer)
    {
    // Display response JSON
    
    self.textView.attributedText = [JSONAttributedFormatter
    attributedStringFromObject:dictionary
    style:nil];
    
    // Any properties from the documentation can be accessed through the keyed accessors, e.g.:
    
    HoundDataHoundServer* houndServer = response;
    
    HoundDataCommandResult* commandResult = houndServer.allResults.firstObject;
    
    NSDictionary* nativeData = commandResult[@"NativeData"];
    
    NSLog(@"NativeData: %@", nativeData);
    }
    }
    });
    }
    ];
    
    }
    
        ~~~~~~~~~~~~~~~END TRANSLATING CODE~~~~~~~~~~~~~~~~~~~~*/
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSearchResults" {
            let controller = segue.destinationViewController as! SearchResultsViewController
            controller.query = status.text
            status.text = nil
        }
    }

}


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~REFERENCE CODE FROM HOUNDSDK Test Application~~~~~~~~~~~~~~~~
- (void)viewDidLoad
    {
        [super viewDidLoad];

        // Setup UI

        [self.searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconSearch
        state:UIControlStateNormal];
        
        self.levelView = [[UIView alloc] init];
        
        self.levelView.backgroundColor = self.view.tintColor;
        
        CGFloat levelHeight = 2.0;
        
        self.levelView.frame = CGRectMake(
        0,
        self.view.frame.size.height - levelHeight,
        0,
        levelHeight
        );
        
        [self.view addSubview:self.levelView];
    }
    
    - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add notifications
    
    [NSNotificationCenter.defaultCenter
    addObserver:self selector:@selector(updateState)
    name:HoundVoiceSearchStateChangeNotification object:nil];
    
    [NSNotificationCenter.defaultCenter
    addObserver:self selector:@selector(audioLevel:)
    name:HoundVoiceSearchAudioLevelNotification object:nil];
    
    [NSNotificationCenter.defaultCenter
    addObserver:self selector:@selector(hotPhrase)
    name:HoundVoiceSearchHotPhraseNotification object:nil];
    
    [self updateState];
    }
    
    - (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    }
    
    - (UIStatusBarStyle)preferredStatusBarStyle
        {
            return UIStatusBarStyleLightContent;
        }
        
        - (void)startSearch
            {
                self.textView.text = nil;
                
                NSDictionary* requestInfo = @{
                    
                    // insert any additional parameters
                };
                
                NSURL* endPointURL = [NSURL URLWithString:VOICE_SEARCH_END_POINT];
                
                // Start voice search
                
                [HoundVoiceSearch.instance
                    startSearchWithRequestInfo:requestInfo
                    endPointURL:endPointURL
                    
                    responseHandler:^(NSError* error, HoundVoiceSearchResponseType responseType, id response, NSDictionary* dictionary) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (error)
                    {
                    // Handle error
                    
                    self.textView.text = error.localizedDescription;
                    }
                    else
                    {
                    if (responseType == HoundVoiceSearchResponseTypePartialTranscription)
                    {
                    // Handle partial transcription
                    
                    HoundDataPartialTranscript* partialTranscript = (HoundDataPartialTranscript*)response;
                    
                    self.textView.text = partialTranscript.partialTranscript;
                    }
                    else if (responseType == HoundVoiceSearchResponseTypeHoundServer)
                    {
                    // Display response JSON
                    
                    self.textView.attributedText = [JSONAttributedFormatter
                    attributedStringFromObject:dictionary
                    style:nil];
                    
                    // Any properties from the documentation can be accessed through the keyed accessors, e.g.:
                    
                    //~~~~~~~~~~9:30 PM I"M STUCK HERE!!!!!~~~~~~~~~~~~~~~~~~

                    HoundDataHoundServer* houndServer = response;
                    
                    HoundDataCommandResult* commandResult = houndServer.allResults.firstObject;
                    
                    NSDictionary* nativeData = commandResult[@"NativeData"];
                    
                    NSLog(@"NativeData: %@", nativeData);
                    }
                    }
                    });
                    }
                ];
                
            }
            
            - (void)updateState
                {
                    [self removeClearButtonFromView:self.searchBar];
                    
                    // Update UI state based on voice search state
                    
                    switch (HoundVoiceSearch.instance.state)
                    {
                    case HoundVoiceSearchStateNone:
                        
                        self.listeningButton.selected = NO;
                        
                        self.searchBar.text = @"Not Ready";
                        
                        self.searchButton.userInteractionEnabled = NO;
                        
                        [self.searchButton setTitle:@"" forState:UIControlStateNormal];
                        
                        self.searchButton.hidden = YES;
                        
                        self.searchBar.showsCancelButton = NO;
                        
                        break;
                        
                    case HoundVoiceSearchStateReady:
                        
                        self.searchBar.text = @"Ready";
                        
                        self.searchButton.userInteractionEnabled = YES;
                        
                        [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
                        
                        self.searchButton.backgroundColor = self.view.tintColor;
                        self.searchButton.hidden = NO;
                        
                        self.searchBar.showsCancelButton = NO;
                        
                        break;
                        
                    case HoundVoiceSearchStateRecording:
                        
                        self.searchBar.text = @"Recording";
                        
                        self.searchButton.userInteractionEnabled = YES;
                        
                        [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
                        
                        self.searchButton.backgroundColor = self.view.tintColor;
                        self.searchButton.hidden = NO;
                        
                        self.searchBar.showsCancelButton = YES;
                        
                        [self enableButtonInView:self.searchBar];
                        
                        break;
                        
                    case HoundVoiceSearchStateSearching:
                        
                        self.searchBar.text = @"Searching";
                        
                        self.searchButton.userInteractionEnabled = YES;
                        
                        [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
                        
                        self.searchButton.backgroundColor = self.view.tintColor;
                        self.searchButton.hidden = NO;
                        
                        self.searchBar.showsCancelButton = NO;
                        
                        break;
                        
                    case HoundVoiceSearchStateSpeaking:
                        
                        self.searchBar.text = @"Speaking";
                        
                        self.searchButton.userInteractionEnabled = YES;
                        
                        [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
                        
                        self.searchButton.backgroundColor = UIColor.redColor;
                        self.searchButton.hidden = NO;
                        
                        self.searchBar.showsCancelButton = NO;
                        
                        break;
                    }
                }
                
                - (void)audioLevel:(NSNotification*)notification
{
    // Display current audio level
    
    float audioLevel = [notification.object floatValue];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear
        | UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:0.05
        delay:0.0 options:options
        
        animations:^{
        
        self.levelView.frame = CGRectMake(
        0,
        self.view.frame.size.height - self.levelView.frame.size.height,
        audioLevel * self.view.frame.size.width,
        self.levelView.frame.size.height
        );
        }
        
        completion:^(BOOL finished) {
        }
    ];
    }
    
    - (void)hotPhrase
        {
            // "OK Hound" detected
            
            [self startSearch];
        }
        
        - (IBAction)listeningButtonTapped
            {
                self.listeningButton.enabled = NO;
                
                if (!self.listeningButton.selected)
                {
                    // Start listening
                    
                    [HoundVoiceSearch.instance
                        
                        startListeningWithCompletionHandler:^(NSError* error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.listeningButton.enabled = YES;
                        self.listeningButton.selected = YES;
                        
                        if (error)
                        {
                        self.textView.text = error.localizedDescription;
                        }
                        });
                        }
                    ];
                }
                else
                {
                    self.textView.text = nil;
                    
                    // Stop listening
                    
                    [HoundVoiceSearch.instance
                        
                        stopListeningWithCompletionHandler:^(NSError *error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.listeningButton.enabled = YES;
                        self.listeningButton.selected = NO;
                        
                        if (error)
                        {
                        self.textView.text = error.localizedDescription;
                        }
                        });
                        }
                    ];
                }
            }
            
            - (IBAction)searchButtonTapped
                {
                    // Take action based on current voice search state
                    
                    switch (HoundVoiceSearch.instance.state)
                    {
                    case HoundVoiceSearchStateNone:
                        
                        break;
                        
                    case HoundVoiceSearchStateReady:
                        
                        [self startSearch];
                        
                        break;
                        
                    case HoundVoiceSearchStateRecording:
                        
                        [HoundVoiceSearch.instance stopSearch];
                        
                        break;
                        
                    case HoundVoiceSearchStateSearching:
                        
                        [HoundVoiceSearch.instance cancelSearch];
                        
                        break;
                        
                    case HoundVoiceSearchStateSpeaking:
                        
                        [HoundVoiceSearch.instance stopSpeaking];
                        
                        break;
                    }
                }
                
                - (void)enableButtonInView:(UIView*)view
{
    for (UIButton* button in view.subviews)
    {
        if ([button isKindOfClass:UIButton.class])
        {
            button.enabled = YES;
        }
        
        [self enableButtonInView:button];
    }
    }
    
    - (void)removeClearButtonFromView:(UIView*)view
{
    for (UITextField* textField in view.subviews)
    {
        if ([textField isKindOfClass:UITextField.class])
        {
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            textField.textColor = UIColor.whiteColor;
        }
        
        [self removeClearButtonFromView:textField];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    return NO;
    }
    
    - (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    if (HoundVoiceSearch.instance.state == HoundVoiceSearchStateRecording)
    {
        [HoundVoiceSearch.instance cancelSearch];
    }
}

@end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END HOUNDSDK Test App Code~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~OLD CODE FOR HOUNDIFY Test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//@property(nonatomic, strong) IBOutlet UILabel* statusLabel; //Use @IBOutlet
@IBOutlet weak var statusLabel: UILabel!

//@property(nonatomic, strong) IBOutlet UITextView* responseTextView;
@IBOutlet weak var responseTextView: UITextView!

@IBOutlet weak var searchField: UITextField!

override func viewDidLoad() {
super.viewDidLoad()

// Do any additional setup after loading the view.
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}

@IBAction func search(button: UIButton) {
//self.statusLabel.text = nil
//self.responseTextView.text = nil

let URL = NSURL(string:VOICE_SEARCH_END_POINT)

//Insert section for request parameters

Houndify.instance().presentListeningViewControllerInViewController(self.navigationController, fromView: button, requestInfo: nil, endPointURL: URL) { error, response, dictionary in

// error stuff for now

if (error != nil) {
print(error.localizedDescription);
print("Search failed")
} else {
let commandResult = response.allResults.firstObject()
//self.responseTextView.text = commandResult.writtenResponse

}

self.dismissSearch()

//~~~END ERROR STUFF


}
}

func dismissSearch(){
Houndify.instance().dismissListeningViewControllerAnimated(true, completionHandler: nil)
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END OLD CODE FOR HOUNDIFY Test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

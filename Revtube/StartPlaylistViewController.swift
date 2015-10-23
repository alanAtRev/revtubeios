//
//  StartPlaylistViewController.swift
//  Revtube
//
//  Created by Alan Baker on 10/23/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class StartPlaylistViewController: UIViewController, ParseServiceDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!
    
    @IBOutlet var activtyIndicator: UIActivityIndicatorView!
    @IBOutlet var joinPartyButton: UIButton!
    
    var parseService : ParseService?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        parseService = ParseService(delegate: self)
    }
    
    override func viewDidLoad() {
        titleLabel.text = "Creating Party..."
        codeLabel.hidden = true
        activtyIndicator.hidden = false
        joinPartyButton.hidden = true
        parseService?.addPlayList()
    }
    
    func onPlaylistSaved(code: String) {
        titleLabel.text = "Party Started!"
        codeLabel.hidden = false
        codeLabel.text = code;
        activtyIndicator.hidden = true
        joinPartyButton.hidden = false
        savePartyHost(code)
    }
    
    func savePartyHost(code: String) {
        let data =  NSUserDefaults.standardUserDefaults()
        var likes = data.arrayForKey("hostParties")
        if(likes == nil) {
            likes = [String]()
        }
        likes!.append(code)
        data.setValue(likes, forKey: "hostParties")
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToPlaylist" {
            let controller: GuestPlaylistController = segue.destinationViewController as! GuestPlaylistController
            controller.playlistCode = codeLabel.text
        }
    }
    
    func onParseError(message: String, error: NSError) {
        let alertController = UIAlertController(title: "Oh no!", message:
            "There is a problem creating your party, please try again",
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alertController,
            animated: true, completion: nil)
    }

}

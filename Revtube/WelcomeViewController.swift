//
//  WelcomeViewController.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var codeField: UITextField!
    
    @IBAction func onJoinButtonTapped(sender: AnyObject) {
        if codeField.text!.characters.count > 0 {
            performSegueWithIdentifier("showGuestPlaylist", sender: self)
        } else {
            let alertController = UIAlertController(title: "Invalid Code", message:
                "Please enter a valid code", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGuestPlaylist" {
            let controller: GuestPlaylistController = segue.destinationViewController as! GuestPlaylistController
            controller.playlistCode = codeField.text
        }
    }

}

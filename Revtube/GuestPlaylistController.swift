//
//  GuestPlaylistController.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class GuestPlaylistController : UIViewController, ParseServiceDelegate {
    
    @IBOutlet var findingPartyView: UIView!
    
    var parseService : ParseService?
    var playList : Playlist?
    var playListItems : [PlaylistItem]?
    
    
    let playlistObjectId = "vxLtIafOqa"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseService = ParseService(delegate: self)
    }
    
    
    override func viewDidLoad() {
        parseService?.getPlaylistWithId(playlistObjectId)
    }
    
    
    func onParseError(message: String, error: NSError) {
        let alertController = UIAlertController(title: "Oh no!", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        findingPartyView.hidden = false
    }
    
    func onPlaylistRetrievedSuccess(playList: Playlist) {
        self.playList = playList
        self.navigationItem.title = playList.code
        parseService?.getPlaylistItemsForPlaylist(self.playList!.objectId!)
    }
    
    func onPlaylistItemsRetrieved(playlistItems: [PlaylistItem]) {
        self.playListItems = playlistItems
        NSLog("\(playlistItems)")
        self.findingPartyView.hidden = true
    }
}
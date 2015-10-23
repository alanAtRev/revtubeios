//
//  GuestPlaylistController.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class GuestPlaylistController : UIViewController, ParseServiceDelegate,
    UITableViewDataSource, UITableViewDelegate, PlayListItemTableViewCellDelegate {
    
    @IBOutlet var findingPartyView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var parseService : ParseService?
    var playList : Playlist?
    var playListItems : [PlaylistItem]?
    var timer : NSTimer?
    
    var likedItems : [String] = [String]()
    var playlistCode: String?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        parseService = ParseService(delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.hidden = true
        findingPartyView.hidden = false
        loadTable()
    }
    
    func loadTable()
    {
        NSLog("loading data")
        parseService?.getPlaylistWithCode(playlistCode!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        destroyTimer()
    }

    func createTimer() {
        if timer == nil {
            NSLog("Timer Started")
            timer = NSTimer.scheduledTimerWithTimeInterval(10.0,
                target: self,
                selector: Selector("loadTable"),
                userInfo: nil,
                repeats: true)
        }
    }
    
    func destroyTimer() {
        if timer != nil {
            NSLog("Timer Ended")
            timer?.invalidate()
            timer = nil
        }
    }
    
    func onParseError(message: String, error: NSError) {
        let alertController = UIAlertController(title: "Oh no!", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction) in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alertController,
            animated: true, completion: nil)
        findingPartyView.hidden = false
    }
    
    func onPlaylistRetrievedSuccess(playList: Playlist) {
        self.playList = playList
        AppDelegate.currentPlayListId = playList.objectId
        self.navigationItem.title = "Code: \(playList.code!)"
        parseService?.getPlaylistItemsForPlaylist(self.playList!.objectId!)
    }
    
    func onPlaylistItemsRetrieved(playlistItems: [PlaylistItem]) {
        self.playListItems = playlistItems
        self.findingPartyView.hidden = true
        self.tableView.hidden = false
        self.tableView.reloadData()
        createTimer()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PlayListItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("playlistItemTableViewCells") as! PlayListItemTableViewCell
        if(likedItems.contains(playListItems![indexPath.row].objectId!)) {
            playListItems![indexPath.row].liked = true
        }
        cell.playListItem = playListItems![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListItems?.count ?? 0
    }
    
    func likeButtonTapped(playListItem: PlaylistItem) {
        likedItems.append(playListItem.objectId!)
        destroyTimer()
        parseService?.likePlayListItem(playListItem)
        loadTable()
    }
}
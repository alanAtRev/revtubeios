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
    @IBOutlet var emptyListMessage: UILabel!
    @IBOutlet var addVideoButton: UIButton!
    
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
    
    override func viewDidLoad() {
        tableView.hidden = true
        addVideoButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.hidden = true
        addVideoButton.hidden = true
        emptyListMessage.hidden = true
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToSearch" {
            let controller: AddToPlaylistController = segue.destinationViewController as! AddToPlaylistController
            controller.playList = playList
        }
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
        if(isPartyHost(playList.code!)) {
             self.navigationItem.title = "Host of \(playList.code!)"
        } else {
            self.navigationItem.title = "Code: \(playList.code!)"
        }
        parseService?.getPlaylistItemsForPlaylist(self.playList!.objectId!)
    }
    
    func onPlaylistItemsRetrieved(playlistItems: [PlaylistItem]) {
        self.playListItems = playlistItems;
        self.findingPartyView.hidden = true
        self.tableView.hidden = false
        self.addVideoButton.hidden = false
        
        if self.playListItems?.count > 0 {
            self.tableView.hidden = false
            self.emptyListMessage.hidden = true
            self.tableView.reloadData()
        } else {
            self.tableView.hidden = true
            self.emptyListMessage.hidden = false
        }
    
        createTimer()
    }
    
    // UITableView Delegate and Datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell: CurrentlyPlayingItemTableViewCell =
                self.tableView.dequeueReusableCellWithIdentifier("currentlyPlayingTableViewCell") as! CurrentlyPlayingItemTableViewCell
            let item = itemForIndexPath(indexPath)
            cell.playListItem = item
            return cell
        }
        
        let cell: PlayListItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("playlistItemTableViewCells") as! PlayListItemTableViewCell
        let item = itemForIndexPath(indexPath)
        item.liked = isLiked(item.objectId!)
        cell.playListItem = item
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: PlayListHeaderCell = self.tableView.dequeueReusableCellWithIdentifier("playlistHeader") as! PlayListHeaderCell
        if section == 0 {
            cell.setTitle("On Now")
        } else {
            cell.setTitle("Up Next")
        }
        return cell;
    }
    
    func itemForIndexPath(indexPath: NSIndexPath) -> PlaylistItem {
        if indexPath.section == 0  {
            return playListItems![0]
        } else {
            return playListItems![indexPath.row + 1]
        }
    }
    
    func saveLikes(playListItemObjectId : String) {
        let data =  NSUserDefaults.standardUserDefaults()
        var likes = data.arrayForKey("likes")
        if(likes == nil) {
            likes = [String]()
        }
        likes!.append(playListItemObjectId)
        data.setValue(likes, forKey: "likes")
    }
    
    func isLiked(playListItemObjectId: String) -> Bool {
        let data =  NSUserDefaults.standardUserDefaults()
        if let likes:[String] = data.arrayForKey("likes") as? [String]{
            return likes.contains(playListItemObjectId)
        }
        return false
    }
    
    func isPartyHost(code: String) -> Bool {
        let data =  NSUserDefaults.standardUserDefaults()
        if let likes:[String] = data.arrayForKey("hostParties") as? [String]{
            return likes.contains(code)
        }
        return false
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playListItems?.count > 0 {
            switch section {
                case 0:
                    return 1;
                case 1:
                    return (playListItems?.count)! - 1
                default:
                    return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let code = playList?.code {
            if indexPath.section != 0 {
                return isPartyHost(code)
            }
            return false
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //remove the deleted object from your data source.
            //If your data source is an NSMutableArray, do this
            
            let itemToRemove: PlaylistItem
            if indexPath.section == 0 {
                itemToRemove = playListItems!.removeAtIndex(0)
            } else {
                itemToRemove = playListItems!.removeAtIndex(indexPath.row + 1)
            }
            parseService?.removePlayListItem(itemToRemove.objectId!)
            
            tableView.reloadData()
        }
    }
    
    func likeButtonTapped(playListItem: PlaylistItem) {
        likedItems.append(playListItem.objectId!)
        saveLikes(playListItem.objectId!)
        destroyTimer()
        parseService?.likePlayListItem(playListItem)
        loadTable()
    }
}
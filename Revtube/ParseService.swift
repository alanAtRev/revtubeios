//
//  ParseManager.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import Foundation
import Parse



@objc protocol ParseServiceDelegate {
    
    optional func onPlaylistRetrievedSuccess(playList: Playlist)
    
    optional func onPlaylistItemsRetrieved(playlistItems: [PlaylistItem])
    
    optional func onPlaylistItemSaved()
    
    optional func onPlaylistSaved(code: String)
    
    func onParseError(message: String, error: NSError)
    
}

class ParseService : NSObject {
    
    var delegate : ParseServiceDelegate?
    
    init(delegate: ParseServiceDelegate?) {
        self.delegate = delegate
    }
    
    func getPlaylistWithId(objectId: String) {
        let query = PFQuery(className: "Playlist")
        query.getObjectInBackgroundWithId(objectId) {
            (parsePlaylist: PFObject?, error: NSError?) -> Void in
            if error == nil && parsePlaylist != nil {
                let playlist = Playlist.playlistFromParseObject(parsePlaylist!)
                self.delegate?.onPlaylistRetrievedSuccess?(playlist)
            } else {
                self.delegate?.onParseError("Could not retrieve playist", error: error!)
            }
        }
    }
    
    func getPlaylistWithCode(code: String) {
        let query = PFQuery(className: "Playlist")
        query.whereKey("code", equalTo: code)
        query.getFirstObjectInBackgroundWithBlock() {
            (parsePlaylist: PFObject?, error: NSError?) -> Void in
            if error == nil && parsePlaylist != nil {
                let playlist = Playlist.playlistFromParseObject(parsePlaylist!)
                self.delegate?.onPlaylistRetrievedSuccess?(playlist)
            } else {
                self.delegate?.onParseError("Could not retrieve playist", error: error!)
            }
        }
    }
    
    func getPlaylistItemsForPlaylist(playlistObjectId: String) {
        let query = PFQuery(className: "PlaylistItem")
        query.whereKey("Playlist", equalTo: PFObject(withoutDataWithClassName: "Playlist", objectId: playlistObjectId))
        query.orderByDescending("likes")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                var items = [PlaylistItem]()
                if(objects == nil || objects!.count == 0) {
                    self.delegate?.onPlaylistItemsRetrieved?(items);
                }
                for object in objects! {
                    items.append(PlaylistItem.PlaylistItemFromParseObject(object))
                }
                self.delegate?.onPlaylistItemsRetrieved?(items);
                
            } else {
                self.delegate?.onParseError("Could not retrieve playist items", error: error!)
            }
        }
    }
    
    func likePlayListItem(item : PlaylistItem) {
        let query = PFQuery(className:"PlaylistItem")
        query.getObjectInBackgroundWithId(item.objectId!) {
            (playlistItem: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let playlistItem = playlistItem {
                playlistItem["likes"] = playlistItem["likes"] as! Int + 1;
                playlistItem.saveInBackground()
            }
        }
    }
    
    func addPlayListItem(playlistObjectId: String, videoId: String, videoTitle: String, videoThumbnail: String) {
        let item = PFObject(className: "PlaylistItem")
        item["Playlist"] = PFObject(withoutDataWithClassName: "Playlist", objectId: playlistObjectId)
        item["videoId"]  = videoId
        item["videoTitle"] = videoTitle
        item["videoThumbnail"] = videoThumbnail
        item["likes"] = 1
        
        item.saveInBackgroundWithBlock() {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
               self.delegate?.onPlaylistItemSaved!()
            } else {
                self.delegate?.onParseError("Error adding item to playlist", error: error!)
            }
        }
    }
    
    func addPlayList() {
        let item = PFObject(className: "Playlist")
        item["code"] = randomStringWithLength(4);
        
        item.saveInBackgroundWithBlock() {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.delegate?.onPlaylistSaved!(item["code"] as! String)
            } else {
                self.delegate?.onParseError("Error creating playlist", error: error!)
            }
        }
    }

    
    private func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
}

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

}

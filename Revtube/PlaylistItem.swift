//
//  PlaylistItem.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import Foundation
import Parse

class PlaylistItem : NSObject {
    
    var objectId : String?
    var videoId : String?
    var likes : Int?
    
    init(objectId: String, videoId: String, likes: Int) {
        self.objectId = objectId
        self.videoId = videoId
        self.likes = likes
    }
    
    static func PlaylistItemFromParseObject(parseObject: PFObject) -> PlaylistItem {
        return PlaylistItem(objectId: parseObject.objectId!,
            videoId: parseObject["videoId"] as! String,
            likes: parseObject["likes"] as! Int)
    }
}
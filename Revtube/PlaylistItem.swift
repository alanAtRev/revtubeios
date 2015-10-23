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
    var videoTitle : String?
    var videoDuration : Int?
    var videoThumbnail : String?
    var likes : Int?
    var liked :Bool = false
    
    init(objectId: String,
        videoId: String,
        videoTitle: String,
        videoDuration: Int,
        videoThumbnail: String,
        likes: Int)
    {
        self.objectId = objectId
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.videoDuration = videoDuration
        self.videoThumbnail = videoThumbnail
        self.likes = likes
        
    }
    
    static func PlaylistItemFromParseObject(parseObject: PFObject) -> PlaylistItem {
        return PlaylistItem(objectId: parseObject.objectId!,
            videoId: parseObject["videoId"] as? String ?? "",
            videoTitle: parseObject["videoTitle"] as? String ?? "",
            videoDuration: 90,
            videoThumbnail: parseObject["videoThumbnail"] as? String ?? "",
            likes: parseObject["likes"] as? Int ?? 1)
    }
    
}
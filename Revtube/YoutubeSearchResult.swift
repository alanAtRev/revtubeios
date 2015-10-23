//
//  YoutubeSearchResult.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import Foundation

class YoutubeSearchResult : NSObject {
    
    var videoId: String
    var thumbnailUrl : String
    var title : String
    
    init(videoId: String, thumbnailUrl: String, title: String) {
        self.videoId = videoId
        self.thumbnailUrl = thumbnailUrl
        self.title = title
    }
}

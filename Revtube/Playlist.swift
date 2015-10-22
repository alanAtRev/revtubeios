//
//  Playlist.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import Foundation
import Parse

class Playlist : NSObject {
    
    var objectId : String?
    var code : String?
    
    init(
        objectId: String,
        code : String) {
        self.objectId = objectId
        self.code = code
    }
    
    static func playlistFromParseObject(parseObject : PFObject) -> Playlist {
        return Playlist(objectId: parseObject.objectId!,
            code: parseObject["code"] as! String)
    }
}
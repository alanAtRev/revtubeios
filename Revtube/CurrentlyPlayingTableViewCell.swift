//
//  CurrentlyPlayingTableViewCell.swift
//  Revtube
//
//  Created by Alan Baker on 10/23/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class CurrentlyPlayingItemTableViewCell : UITableViewCell {
    
    @IBOutlet var videoThumbnailImageView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    
    var playListItem : PlaylistItem? {
        didSet {
            ImageLoader.sharedLoader.imageForUrl(playListItem!.videoThumbnail!,
                completionHandler:{
                    (image: UIImage?, url: String) in
                    self.videoThumbnailImageView.image = image
            })
            
            videoTitleLabel.text = playListItem!.videoTitle
        }
    }
    
}


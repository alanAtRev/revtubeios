//
//  PlaylistItemTableViewCell.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

protocol PlayListItemTableViewCellDelegate {
    
    func likeButtonTapped(playListItem : PlaylistItem)
}

class PlayListItemTableViewCell : UITableViewCell {
    
    @IBOutlet var videoThumbnailImageView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var playListItem : PlaylistItem? {
        didSet {
            ImageLoader.sharedLoader.imageForUrl(playListItem!.videoThumbnail!,
                completionHandler:{
                (image: UIImage?, url: String) in
                    self.videoThumbnailImageView.image = image
            })

            videoTitleLabel.text = playListItem!.videoTitle
            var durationText = "\(playListItem!.videoDuration! / 60):"
            if playListItem!.videoDuration! % 60 < 10 {
                durationText += "0\(playListItem!.videoDuration! % 60)"
            } else {
                durationText += "\(playListItem!.videoDuration! % 60)"
            }
            durationLabel.text = durationText
            likesLabel.text = "\(playListItem!.likes!) likes"
            
            if(playListItem!.liked) {
                likeButton.enabled = false
                likeButton.backgroundColor = UIColor.grayColor()
                likeButton.setTitle("Liked", forState: UIControlState.Disabled)
            } else {
                likeButton.enabled = true
                likeButton.backgroundColor = UIColor(r: 48, g: 131, b: 251)
                likeButton.setTitle("Like", forState: UIControlState.Normal)
            }
        }
    }
    
    var delegate : PlayListItemTableViewCellDelegate?
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        delegate?.likeButtonTapped(playListItem!)
        likesLabel.text = "\(playListItem!.likes! + 1) likes"
        likeButton.enabled = false
        likeButton.backgroundColor = UIColor.grayColor()
        likeButton.setTitle("Liked", forState: UIControlState.Disabled)
    }
}

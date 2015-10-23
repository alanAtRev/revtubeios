//
//  YouTubeResultTableViewCell.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

protocol YouTubeResultTableViewCellDelegate {
    func addPlayListItem(result: YoutubeSearchResult)
}

class YouTubeResultTableViewCell: UITableViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var delegate: YouTubeResultTableViewCellDelegate?
    
    var result: YoutubeSearchResult? {
        didSet {
            ImageLoader.sharedLoader.imageForUrl(result!.thumbnailUrl,
                completionHandler:{
                    (image: UIImage?, url: String) in
                    self.thumbnailImageView.image = image
            })
            titleLabel.text = result!.title
            
            if(result!.added) {
                addButton.enabled = false
                addButton.backgroundColor = UIColor.grayColor()
                addButton.setTitle("Added", forState: UIControlState.Disabled)
            } else {
                addButton.enabled = true
                addButton.backgroundColor = UIColor(r: 48, g: 131, b: 251)
                addButton.setTitle("Added", forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func onAddButtonTapped(sender: AnyObject) {
        self.delegate?.addPlayListItem(result!)
        addButton.enabled = false
        addButton.backgroundColor = UIColor.grayColor()
        addButton.setTitle("Added", forState: UIControlState.Disabled)
    }
}

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
        }
    }
    
    @IBAction func onAddButtonTapped(sender: AnyObject) {
        self.delegate?.addPlayListItem(result!)
    }
}

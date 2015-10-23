//
//  AddToPlaylistController.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class AddToPlaylistController : UIViewController, YoutubeSearchServiceDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate, ParseServiceDelegate, YouTubeResultTableViewCellDelegate {
    
    var parseService : ParseService?
    var youtubeService: YoutubeSearchService?
    var playList: Playlist?
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var results: [YoutubeSearchResult]?
    var added: [String]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseService = ParseService(delegate: self)
        self.youtubeService = YoutubeSearchService(delegate: self)
        added = [String]()
    }
    
    override func viewDidLoad() {
        results = [YoutubeSearchResult]()
        performSearch("")
        searchField.delegate = self
        searchField.returnKeyType = .Search
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        onSearchButtonTapped(textField)
        searchField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSearchButtonTapped(sender: AnyObject) {
        if let query = searchField.text {
            performSearch(query)
        }
    }
    
    private func performSearch(query: String) {
        youtubeService?.searchYoutube(query)
    }
    
    func onSearchReturned(results: [YoutubeSearchResult]) {
        self.results = results
        self.tableView.reloadData()
    }
    
    //UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: YouTubeResultTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("resultItemTableViewCells") as! YouTubeResultTableViewCell
        if added!.contains(results![indexPath.row].videoId) {
            results![indexPath.row].added = true
        } else {
            results![indexPath.row].added = false
        }
        cell.result = results![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    //YoutubeSearchResultTableViewCellDelegate
    func addPlayListItem(result: YoutubeSearchResult) {
        added?.append(result.videoId)
        parseService?.addPlayListItem(playList!.objectId!,
            videoId: result.videoId,
            videoTitle: result.title,
            videoThumbnail: result.thumbnailUrl)
    }
    
    func onParseError(message: String, error: NSError) {
        let alertController = UIAlertController(title: "Oh no!", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

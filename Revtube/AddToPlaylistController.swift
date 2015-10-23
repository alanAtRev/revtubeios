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
    UITableViewDelegate {
    
    var youtubeService: YoutubeSearchService?
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var results: [YoutubeSearchResult]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.youtubeService = YoutubeSearchService(delegate: self)
    }
    
    override func viewDidLoad() {
        results = [YoutubeSearchResult]()
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
        cell.result = results![indexPath.row]
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

}

//
//  YoutubeSearchService.swift
//  Revtube
//
//  Created by Alan Baker on 10/22/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import Foundation

protocol YoutubeSearchServiceDelegate {
    
    func onSearchReturned(results: [YoutubeSearchResult])
    
}

class YoutubeSearchService : NSObject {
    
    var delegate: YoutubeSearchServiceDelegate?
    
    init(delegate: YoutubeSearchServiceDelegate) {
        self.delegate = delegate
    }
    
    func searchYoutube(query : String) {
        // Set up your URL
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let youtubeApi: String = "https://content.googleapis.com/youtube/v3/search?part=snippet&q=" + escapedQuery! + "&type=video&maxResults=10&key=AIzaSyBqf7fU8HgDmRG752sxL1eoff5rSJVIEKk"
        let url: NSURL = NSURL(string: youtubeApi)!
        
        // Create your request
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // Send the request asynchronously
        NSURLConnection.sendAsynchronousRequest(request, queue: queue,
            completionHandler: {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                // Callback, parse the data and check for errors
                if data != nil && error == nil {
                    let result: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,
                            options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let items: NSArray = result["items"] as! NSArray
                    var results: [YoutubeSearchResult] = [YoutubeSearchResult]()
                    for item in items {
                        NSLog("\(item)")
                        let id: NSDictionary = item["id"] as! NSDictionary
                        let videoId: String = id["videoId"] as! String
                        let snippet: NSDictionary = item["snippet"] as! NSDictionary
                        let title: String = snippet["title"] as! String!
                        let thumbnails: NSDictionary = snippet["thumbnails"] as! NSDictionary!
                        let defaultThumbnail: NSDictionary = thumbnails["medium"] as! NSDictionary!
                        let url: String = defaultThumbnail["url"] as! String!
                        results.append(YoutubeSearchResult(videoId: videoId, thumbnailUrl: url, title: title))
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.onSearchReturned(results)
                    })
                }
        })
    }

}

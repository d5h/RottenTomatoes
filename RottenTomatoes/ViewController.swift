//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Dan Hipschman on 2/3/15.
//  Copyright (c) 2015 Dan Hipschman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var movieData: NSArray = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=7b3zwfv9dhhvhwu52h8kb3yg"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            if error != nil || data == nil {
                println(error)
                return
            }
            var jsonError: NSError? = nil
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as NSDictionary
            if error != nil {
                println(error)
                return
            }
            self.movieData = dict["movies"] as NSArray
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as MovieTableViewCell
        let movie = movieData[indexPath.row] as NSDictionary
        cell.movieTitle.text = movie["title"] as? String
        let url = movie.valueForKeyPath("posters.thumbnail") as String
        cell.posterView.setImageWithURL(NSURL(string: url))
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let details = MovieDetailsViewController()
        details.details = movieData[indexPath.row] as NSDictionary
        navigationController?.pushViewController(details, animated: true)
    }
}


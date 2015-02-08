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
    var networkErrorView: UILabel?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "getData", forControlEvents: UIControlEvents.ValueChanged)
        
        getData()
    }
    
    func getData() {
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=7b3zwfv9dhhvhwu52h8kb3yg"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            // Prints a warning when not refreshing (first load), so shouldn't do this
            self.refreshControl?.endRefreshing()
            if error != nil || data == nil {
                self.showNetworkError()
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
    
    func showNetworkError() {
        if networkErrorView == nil {
            let w = CGRectGetWidth(self.view.frame)
            let frame = CGRectMake(0, 0, w, 24)
            networkErrorView = UILabel(frame: frame)
            networkErrorView?.backgroundColor = UIColor.darkGrayColor()
            networkErrorView?.textColor = UIColor.whiteColor()
            networkErrorView?.textAlignment = NSTextAlignment.Center
            networkErrorView?.text = "Network Error"
        }
        view.addSubview(networkErrorView!)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as MovieTableViewCell
        let details = movieData[indexPath.row] as NSDictionary
        cell.movieTitle.text = details["title"] as? String
        cell.synopsis.text = details["synopsis"] as? String
        let rating = details.valueForKeyPath("ratings.critics_score") as? Int
        cell.rating.text = String(format: "%d%%", rating!)
        let url = details.valueForKeyPath("posters.thumbnail") as String
        cell.posterView.setImageWithURL(NSURL(string: url))
        cell.details = details
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Since we did a seque in the storyboard, this is called before didSelectRowAtIndexPath.
        // Hence, we store the details in the cell.
        // Note that the source controller is self.  The destination controller is the detail view
        // controller.  The sender is the cell.
        let cell = sender as? MovieTableViewCell
        let detailsView = segue.destinationViewController as MovieDetailsViewController
        detailsView.details = cell?.details
    }
}


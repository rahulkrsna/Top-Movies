//
//  MoviesViewController.swift
//  Top-Movies
//
//  Created by Rahul Krishna Vasantham on 1/6/16.
//  Copyright © 2016 rahulkrnsa. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var movies:[NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let imageURL = NSURL(string: baseURL+posterPath)!
        
        cell.titleLabel.text = title
        cell.overViewLabel.text = overview
        cell.imgView.setImageWithURL(imageURL)
        
        return cell
    }
    
    func retrieveDataFromTMDB() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                // Hide the Progress Bar
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                //In case initated through refresh control end refresh control
                self.refreshControl.endRefreshing()
                if(error == nil) {
                    self.networkErrorView.hidden = true
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                self.tableView.reloadData()
                        }
                    }
                } else {
                    self.networkErrorView.hidden = false
                }
        });
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        networkErrorView.hidden = true
        
        // Adding a refresh control, for pull to refresh feature
        refreshControl = UIRefreshControl()
        // Set the Action for the refresh Control
        refreshControl.addTarget(self, action: "retrieveDataFromTMDB", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0) //Insert the refreshControl(UIView) into the tableView at the top
        
        //Initialized the progress bar and it will be removed once the information is shown to the user.
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        retrieveDataFromTMDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

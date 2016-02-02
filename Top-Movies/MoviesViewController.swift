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

//class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionsView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var networkErrorButton: UIButton!
    var endpoint: String!
    @IBAction func refreshUI(sender: AnyObject) {
        retrieveDataFromTMDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Set Default View Properties
        setViewProperties()
        
        //2. Set Refresh Control
        setRefreshControl()
        
        //Initialized the progress bar and it will be removed once the information is shown to the user.
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        retrieveDataFromTMDB()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBOutlet weak var tableView: UITableView!
    var movies:[NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionsView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! TopMovieCell
        let movie = movies![indexPath.row]
        if let posterPath = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseURL+posterPath)!
            cell.imgView.setImageWithURL(imageURL)
        }
        
        return cell
    }
    
    
    func retrieveDataFromTMDB() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
//        let request = NSURLRequest(URL: url!)
        let request = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 100)
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
                if(error == nil) {
//                    self.networkErrorView.hidden = true
                    self.networkErrorButton.hidden = true
                    self.collectionsView.alpha = 1
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                self.collectionsView.reloadData()
                        }
                    }
                } else {
                    self.networkErrorButton.hidden = false
                    self.collectionsView.alpha = 0
                }
                self.refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    func setViewProperties() {
        
        //        tableView.dataSource = self
        //        tableView.delegate = self
        collectionsView.dataSource = self
        collectionsView.delegate = self
        
        //Layout
//        flowLayout.minimumLineSpacing = 1
//        flowLayout.minimumInteritemSpacing = 0
//        flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0)
        
        //By default put the network error view hidden
//        networkErrorView.hidden = true
        networkErrorButton.hidden = true
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        retrieveDataFromTMDB()
    }
    
    func setRefreshControl() {
        
        // Adding a refresh control, for pull to refresh feature
        refreshControl = UIRefreshControl()

        // Set the Action for the refresh Control
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)

        //Insert the refreshControl(UIView) into the tableView at the top
        // tableView.insertSubview(refreshControl, atIndex: 0)
        
        collectionsView.insertSubview(refreshControl, atIndex: 0)
    }
    
    /*
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
    let overview = movie["overview"] as? String
    if let posterPath = movie["poster_path"] as? String {
    let baseURL = "http://image.tmdb.org/t/p/w500"
    let imageURL = NSURL(string: baseURL+posterPath)!
    cell.imgView.setImageWithURL(imageURL)
    }
    cell.titleLabel.text = title
    cell.overViewLabel.text = overview
    
    return cell
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionsView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
}

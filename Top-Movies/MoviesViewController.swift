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
class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet var collectionsView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var networkErrorButton: UIButton!
    @IBOutlet var search: UISearchBar!
    
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
    var filteredMovies:[NSDictionary]?
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionsView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! TopMovieCell
        let movie = filteredMovies![indexPath.row]
        if let posterPath = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseURL+posterPath)!
            let imageRequest = NSURLRequest(URL: imageURL)
//            cell.imgView.setImageWithURL(imageURL)
            cell.imgView.setImageWithURLRequest(imageRequest,
                placeholderImage: nil,
                success: { (imageReq, imageRes, image) -> Void in
                    
                    if(imageRes != nil) {
                        cell.imgView.alpha = 0.0
                        cell.imgView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.imgView.alpha = 1.0
                        })
                    } else {
                        cell.imgView.image = image // From cached images
                    }
                }, failure: { (imageReq, imageRes, error) -> Void in
                    print("Image can't be loaded")
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionsView.cellForItemAtIndexPath(indexPath) as! TopMovieCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.yellowColor()
        cell.selectedBackgroundView = backgroundView
        collectionsView.deselectItemAtIndexPath(indexPath, animated: true)
        //cell.sendSubviewToBack(cell.imgView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(collectionView.bounds.width/2 - 4, 200);
    }
    
    func retrieveDataFromTMDB() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                    self.networkErrorButton.hidden = true
                    self.collectionsView.alpha = 1
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                self.filteredMovies = self.movies
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
        
        collectionsView.dataSource = self
        collectionsView.delegate = self
        
        search.delegate = self
        
        //Layout
        flowLayout.minimumLineSpacing = 2
//        flowLayout.minimumInteritemSpacing = 2
        flowLayout.sectionInset = UIEdgeInsetsMake(0,2,0,2)
        
        //By default put the network error view hidden
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        
        let indexPath = collectionsView.indexPathForCell(cell)
        let movie = filteredMovies![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = [NSDictionary]()
        if searchText.isEmpty == false {
            for (_, movie) in (movies?.enumerate())! {
                
                if (movie["title"] as! String).lowercaseString.containsString(searchText.lowercaseString) {
                    filteredMovies?.append(movie)
                }
            }
        } else {
            filteredMovies = movies
        }
        
        collectionsView.reloadData()
//        let filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
//            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//        })
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.search.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        search.showsCancelButton = false
        search.text = ""
        search.resignFirstResponder()
        
        filteredMovies = movies
        collectionsView.reloadData()
    }
    
}

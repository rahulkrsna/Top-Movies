//
//  DetailViewController.swift
//  Top-Movies
//
//  Created by Rahul Krishna Vasantham on 2/1/16.
//  Copyright © 2016 rahulkrnsa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet var posterImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.height + infoView.frame.origin.y)
        
        loadDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  Load Poster, Title and Overview of the movie
    private func loadDetails() {
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
//            let baseURL = "http://image.tmdb.org/t/p/w500"
            let lowResolutionBaseURL = "https://image.tmdb.org/t/p/w45"
            let highResolutionBaseURL = "https://image.tmdb.org/t/p/original"
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: lowResolutionBaseURL+posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: highResolutionBaseURL+posterPath)!)
            
//            let imageURL = NSURL(string: lowResolutionBaseURL+posterPath)!
//            posterImgView.setImageWithURL(imageURL)
            posterImgView.setImageWithURLRequest(smallImageRequest,
                placeholderImage: nil,
                success: { (imageReq, imageRes, smallImg) -> Void in
                    
                    self.posterImgView.alpha = 0.0
                    self.posterImgView.image = smallImg
                    
                    UIView.animateWithDuration(0, animations: { () -> Void in
                        
                        self.posterImgView.alpha = 1.0
                        
                        }, completion: { (success) -> Void in
                            
                            self.posterImgView.setImageWithURLRequest(largeImageRequest,
                                placeholderImage: smallImg,
                                success: { (largeImgReq, largeImgRes, largeImg) -> Void in
                                    
                                    self.posterImgView.image = largeImg
                                    
                                }, failure: { (imgReq, imgRes, error) -> Void in
                                    print("Can't load high resolution image")
                            })
                    })
                }, failure: { (imgReq, imgRes, error) -> Void in
                    print("Can't load images")
            })
        }
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

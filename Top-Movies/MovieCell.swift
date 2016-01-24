//
//  MovieCell.swift
//  Top-Movies
//
//  Created by Rahul Krishna Vasantham on 1/6/16.
//  Copyright © 2016 rahulkrnsa. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

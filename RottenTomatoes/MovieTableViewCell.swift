//
//  MovieTableViewCell.swift
//  RottenTomatoes
//
//  Created by Dan Hipschman on 2/3/15.
//  Copyright (c) 2015 Dan Hipschman. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var details: NSDictionary!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

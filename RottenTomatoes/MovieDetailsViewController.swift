//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Dan Hipschman on 2/3/15.
//  Copyright (c) 2015 Dan Hipschman. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var details: NSDictionary!
    @IBOutlet weak var posterView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tmbUrl = details.valueForKeyPath("posters.original") as String
        let url = tmbUrl.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg")
        SVProgressHUD.show()
        //posterView.setImageWithURL(NSURL(string: url))
        let request = NSURLRequest(URL: NSURL(string: url)!)
        posterView.setImageWithURLRequest(request, placeholderImage: nil,
            success: { request, response, image in
                self.posterView.image = image
                SVProgressHUD.dismiss()
            }, failure: { request, response, image in
                SVProgressHUD.dismiss()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // DO NOT override this (or if you do, call super.  Otherwise
    // posterView won't get initialized.  I guess the default loads
    // the nib.
    //override func loadView() {
    //}
}

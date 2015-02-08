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
        let request = NSURLRequest(URL: NSURL(string: url)!)
        posterView.setImageWithURLRequest(request, placeholderImage: nil,
            success: { request, response, image in
                self.posterView.image = image
                SVProgressHUD.dismiss()
            }, failure: { request, response, image in
                SVProgressHUD.dismiss()
            }
        )
        
        addSynopsis()
    }
    
    func addSynopsis() {
        // it's much easier to set up scroll view programatically than in interface builder!
        let scroll = UIScrollView(frame: view.frame)
        view.addSubview(scroll)
        
        // set the frame width first, as sizeToFit will otherwise put everything on one line
        let labelFrame = CGRectMake(view.frame.origin.x + 8, view.frame.origin.y + 8, view.frame.width - 8, 9999)
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 230, alpha: 1)
        label.text = details["synopsis"] as? String
        label.sizeToFit()
        
        // need to add uilabel to a content view so it goes at the top.  otherwise, the text will
        // float in the vertical center
        let height = view.frame.height / 6 + label.frame.height
        var rect = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width, height)
        rect.origin.y += 5 * view.frame.height / 6
        let contentView = UIView(frame: rect)
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        contentView.addSubview(label)
        scroll.addSubview(contentView)
        scroll.contentSize = CGSizeMake(rect.width, rect.origin.y + rect.height)
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

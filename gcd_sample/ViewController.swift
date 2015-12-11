//
//  ViewController.swift
//  gcd_sample
//
//  Created by Cassis Dev on 11/12/15.
//  Copyright © 2015 heru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // initialize the gcd
    var imgThread:dispatch_queue_t = dispatch_queue_create("myImageThread", DISPATCH_QUEUE_SERIAL)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.startAnimating()
        
        // use gcd to load image from url
        dispatch_async(self.imgThread, {
            self.getDataFromUrl(NSURL(string: "http://freehdwallpaper.net/wp-content/uploads/2015/11/The-Peanuts-Movie-2015-Wallpaper.jpg")!) { (data, response, error) in

                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        // update ui only can be done via main thread
                        self.imgView.image = UIImage(data: data!)
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.hidden = true
                    }
            
                }
        })
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


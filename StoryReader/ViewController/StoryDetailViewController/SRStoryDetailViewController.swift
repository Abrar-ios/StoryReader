//
//  SRStoryDetailViewController.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import UIKit

/**
 The purpose of the `SRStoryDetailViewController` view controller is to provide a user interface where a Selected **Recent Post** available to view in detail.
 
 There's a matching scene in the *Main.storyboard* file, and in that scene there are one Webview, activityindictorview and back navigation button. Go to Interface Builder for details.
 
 The `SRStoryListViewController` class is a subclass of the `UIViewController`, and it conforms to the `UIWebViewDelegate` protocol.
 */

class SRStoryDetailViewController: UIViewController,UIWebViewDelegate {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var webViewDetail: UIWebView!
    @IBOutlet weak var loadingProgress: UIActivityIndicatorView!
    
    var storyDTO: StoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webViewDetail.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        let url = URL(string: (self.storyDTO?._storyURL)!)
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.webViewDetail.loadRequest(request) // load request in webview with request url to show 
                    
                } else {
                    
                    print("ERROR: \(String(describing: error))")
                    
                }
                
            }
            
            task.resume()
            
        }

    }
    
    // MARK: Action method to use back navigation
    
    @IBAction func dismissDetailVC(){
    
        self.dismiss(animated: true, completion: nil)
    
    }
    
    // MARK: Webview delegate Methods to handle webview states.
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Strat Loading")
        self.loadingProgress.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish Loading")
        self.loadingProgress.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription )
    }

    

}

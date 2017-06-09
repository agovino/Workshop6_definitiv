//
//  UrlViewController.swift
//  HotUrls
//
//  Line Stettler & Agovino Marco
//
//  Workshop 6

import UIKit

class UrlViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var hotUrl: HotUrl?
    
    override func loadView() {
        super.loadView()
     
        guard let hotUrl = hotUrl else {
            return
        }
        
        if let url = URL(string: hotUrl.getPrefixedUrl()) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

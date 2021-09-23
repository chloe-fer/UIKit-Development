//
//  WebViewController.swift
//  Project-16
//
//  Created by Chloe Fermanis on 22/9/21.
//

import WebKit
import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var WikiURL: URL!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard WikiURL != nil else {
            print("Website not set")
            return
        }
        
        if let url = WikiURL {
            webView.load(URLRequest(url: url))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

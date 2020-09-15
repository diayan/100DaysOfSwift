//
//  DetailViewController.swift
//  Project7
//
//  Created by diayan siat on 24/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detialItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*  guard unwraps detailItem into itself if it has a value, which makes sure we exit the method if for some reason we didn’t get any data passed to the detail. Note: It’s very common to unwrap variables using the same name, rather than create slight variations. In this case we could have used guard let unwrappedItem = detailItem, but that isn’t any better.*/
        guard let detailItem = detialItem else {return}
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <h2>\(detailItem.title)</h2>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}

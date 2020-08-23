//
//  WebViewController.swift
//  Webview-X
//
//  Created by diayan siat on 15/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var website: String?
    var websites = ["hackingwithswift.com", "apple.com", "youtube.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        //set this to prevent navigation bar from overlapping the webview
        self.edgesForExtendedLayout = []
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //uibarbutton: the flexibleSpace pushes all the uitoolbar buttons to one side until all the space is taken
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        //toolbar lies at the bottom of the screen and holds the actions that come with the default controller
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
        //default page when app starts
        let url = URL(string: "https://" + website!)!
        //turn url into a url request and then webview can load it
        webView.load(URLRequest(url: url))
        //swipe backward and forward for navigation
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //add more options of websites to open when user clicks on open
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        let urlString = url?.absoluteString ?? "Unknown"
        
        if urlString != "about:blank" {
            //show an alert when the user tries to open a blocked url
                   let alertAction = UIAlertController(title: "Blocked", message: "This \"\(urlString)\" is blocked and cannot be accessed", preferredStyle: .alert)
                   alertAction.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                   present(alertAction, animated: true)
        }
       

        decisionHandler(.cancel)
    }
    
    func openPage(action: UIAlertAction){
        //get the title of the action and use that as the new url by adding it to the https
        guard let actionTitle = action.title else{ return }
        guard let url =  URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

//
//  ViewController.swift
//  Webview-X
//
//  Created by diayan siat on 13/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import WebKit

class MainTableViewController: UITableViewController {
    
    var websites = ["hackingwithswift.com", "apple.com", "youtube.com"]
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        title = "Browser X"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.website = websites[indexPath.row]
            print(indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


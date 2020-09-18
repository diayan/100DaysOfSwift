//
//  ViewController.swift
//  Project1
//
//  Created by diayan siat on 04/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    
    var viewCount = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        //enable large titles across the app
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //load user defaults data d
        let defaults = UserDefaults.standard
        viewCount = defaults.object(forKey: "ViewCount") as? [String : Int] ?? [String : Int]()
        
        //fm, path and items will be destroyed as soon as viewdidload finishes
        performSelector(inBackground: #selector(loadPictures), with: nil)
        tableView.reloadData()
    }
    
    
    @objc func loadPictures() {
        //Filemanager allows us to access to local file system
        let fm = FileManager.default
        
        /*declares a constant called path that is set to the resource path of our app's bundle. A bundle is a directory containing our compiled program and all our assets including our images
         So, this line says, "tell me where I can find all those images I added to my app."*/
        let path = Bundle.main.resourcePath!
        
        //items is set to the contents of the directory at a path
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views \(viewCount[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.pictureCount = pictures.count
            vc.pictureNumber = indexPath.row + 1
            
            //project 12 challenge 1
            viewCount[pictures[indexPath.row], default: 0] += 1

            DispatchQueue.global().async { [weak self] in
                self?.saveCount()
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    func saveCount() {
        let defaults = UserDefaults.standard
        defaults.set(viewCount, forKey: "ViewCount")
    }
}


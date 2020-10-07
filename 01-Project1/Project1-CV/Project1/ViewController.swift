//
//  ViewController.swift
//  Project1
//
//  Created by diayan siat on 04/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        //enable large titles across the app
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //fm, path and items will be destroyed as soon as viewdidload finishes
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
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
        print("Pictures: \(pictures)")
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)


    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Unable to deque photo cell")
        }
        
        cell.name.text = pictures[indexPath.row]
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Identifier is "Detail", I am testing exception breakpoints by using the "Bad"
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.pictureCount = pictures.count
            vc.pictureNumber = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


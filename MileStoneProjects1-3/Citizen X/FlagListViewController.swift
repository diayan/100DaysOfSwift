//
//  FlagListViewController.swift
//  Citizen X
//
//  Created by diayan siat on 13/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class FlagListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var flags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //set the tile
        title = "Citizen X"
        
        //enable large titles across the app
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager .default
        
        let path = Bundle.main.resourcePath!
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                flags.append(item)
            }
        }
    }
}

extension FlagListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath) as! FlagCell

        
        let sortedCountries = flags.sorted(by: <)
        let flagName = (sortedCountries[indexPath.row] as NSString).deletingPathExtension
        
        cell.flagImageView?.image = UIImage(named: flagName)
        cell.countryNameLebel.text = flagName
        
        //add border color to imageview
        cell.flagImageView?.layer.borderColor = UIColor.white.cgColor
        cell.flagImageView.layer.borderWidth = 1

        //add corner radius to imageview
        cell.flagImageView.layer.cornerRadius = 4
        cell.flagImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail")
        as? DetailViewController {
            let sortedCountries = flags.sorted(by: <)
            vc.selectedImage = sortedCountries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

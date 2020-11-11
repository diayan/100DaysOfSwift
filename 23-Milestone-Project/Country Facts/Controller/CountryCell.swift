//
//  CountryCell.swift
//  Country Facts
//
//  Created by diayan siat on 27/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var countryNameLabel: UILabel!
    
    func populate(country: Country) {
        
        if let url = URL(string: country.flag) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async { [weak self] in
                    self?.flagImageView.image = UIImage(named: getFlagFileName(code: country.alpha2Code, type: .SD))
                    self?.flagImageView.layer.borderColor = UIColor.black.cgColor
                    self?.flagImageView.layer.borderWidth = 0.5
                    self?.flagImageView.layer.cornerRadius = 5
                    self?.countryNameLabel.text = country.name

                }
            }
            task.resume()
        }else {
            print("failed to download data")
        }
    }
    
    
}

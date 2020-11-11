//
//  ViewController.swift
//  Country Facts

//  Created by diayan siat on 21/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var countryManager = CountryManager()
    var countryCell    = CountryCell()
    var countries      = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        countryManager.delegate = self
        tableView.delegate   = self
        tableView.dataSource = self
        countryManager.performNetworkRequest()
    }
}

extension CountryViewController: CountryManagerDelegate {
    func didUpdateCountry(_ countryManager: CountryManager, country: [Country]) {
        countries = country
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension CountryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let country = countries[indexPath.row]
        cell.populate(country: country)
        return cell
    }
}



//
//  ViewController.swift
//  Project7
//
//  Created by diayan siat on 23/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterWord))
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            //url for original/all json
            
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            
            //cached version incase the live url is disabled
            //urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            //url for petitions that have at least 10,000 signatures
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            
            //cached version incase the live url is disabled
            //urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }else{
            showError()
        }
    }
    
    @objc func filterWord() {
        let ac = UIAlertController(title: "Search for a petition", message: "Type in a word to search a petition", preferredStyle: .alert)
        ac.addTextField()
        
        let search = UIAlertAction(title: "Search", style: .default){ [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else {return}
            
            if !word.isEmpty {
                self?.submit(word: word)
            }
        }

        ac.addAction(search)
        present(ac, animated: true)
    }
    
    func submit(word: String) {
        filteredPetitions.removeAll()
        for petition in petitions {
            let lowerCaseBody = petition.body.lowercased()
            let lowerCaseTitle = petition.title.lowercased()
            
            if lowerCaseBody.contains(word) || lowerCaseTitle.contains(word) {
                filteredPetitions.append(petition)
                print(filteredPetitions)
            }
        }
        tableView.reloadData()
    }
    
    @objc func showCredit() {
        let apiName = "We The People API"
        let ac = UIAlertController(title: "Credits", message: "This data comes from the \(apiName) of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading your the feed: please check your internet connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detialItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


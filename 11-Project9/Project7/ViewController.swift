//
//  ViewController.swift
//  Project7
//
//  Created by diayan siat on 23/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit



//Using GCD to do background works in the this way: you pass it the name of a method to run, and inBackground will //run it on a background thread,and onMainThread will run it on a foreground thread.
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
        
        
        //using GCD to fetch data on a different thread from the main thread
        //to put a task on a background thread, we call async() twice: once to push some code to a background thread, then once more to push code back to the main thread
        //QoS: quality of service: there are four QoS levels; User interactive, user initiated, utility queue and background queue. first two execute almost immediatly without regard for power usage while the last two priorize power usage, the last one especially
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            //showErro() is being called on a background thread eventhouh it does UI work, so it has to be put back onto the main thread
            self.showError()
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
        
        //putting the showError back on the main thread
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading your the feed: please check your internet connection", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            //push the result of the background work back to the main thread
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
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


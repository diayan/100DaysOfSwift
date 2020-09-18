//
//  ViewController.swift
//  Milestone Project4-6
//
//  Created by diayan siat on 22/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptforItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        //add an add button to the right side of the app
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptforItem))
        
        //        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        //
        //        toolbarItems = [refresh]
        //        navigationController?.isToolbarHidden = false
    }
    
    @objc func shareTapped() {
        if !shoppingList.isEmpty {
            let list = shoppingList.joined(separator: "\n")
            
            let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
            
        }else{
            showErrorMessage(errorTitle: "Empty list", errorMessage: "An attempt to share an empty list, add some items and try again")
        }
    }
    @objc func restartGame() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    //method that prompt user to add an item to their shopping list
    @objc func promptforItem() {
        let alertController = UIAlertController(title: "Add an item", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            guard let item = alertController?.textFields?[0].text else {return}
            
            if !item.isEmpty {
                self?.submit(item: item)
            }
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    
    func submit(item: String) {
        let lowerItem = item.lowercased()
        
        if isOriginal(word: lowerItem) {
            shoppingList.insert(lowerItem, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }else{
            showErrorMessage(errorTitle: "Word Exists", errorMessage: "Be more original")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func isOriginal(word: String) -> Bool {
        return !shoppingList.contains(word)
    }
    
    //    func isReal(word: String) -> Bool {
    //        if word.count < 3 || word == title {
    //            return false
    //        }else {
    //            let checker = UITextChecker()
    //            let range = NSRange(location: 0, length: word.utf16.count)
    //            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    //
    //            return misspelledRange.location == NSNotFound
    //        }
    //    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}


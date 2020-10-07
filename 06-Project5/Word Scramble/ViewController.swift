//
//  ViewController.swift
//  Word Scramble
//
//  Created by diayan siat on 16/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    
    var gameState = GameState(currentWord: "", usedWords: [String]())
    var gameStateKey = "GameState"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        //code carefully checks for and unwraps the contents of our start file, then converts it to an array
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        //checks if allwords is empty
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        performSelector(inBackground: #selector(loadGameState), with: nil)
    }
    
    @objc func startGame() {
        gameState.currentWord = allWords.randomElement() ?? "silkworm"
        //removes all values from the usedWords array, which we'll be using to store the player's answers so far
        gameState.usedWords.removeAll(keepingCapacity: true)
        //sets the view controller's title to be a random word in the array which will be the word the player has to find
        DispatchQueue.global().async {[weak self] in
            self?.saveGameState()
            
            DispatchQueue.main.async {
                self?.loadGameStateView()
            }
        }
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            if !answer.isEmpty {
                self?.submit(answer)
            }
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    gameState.usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                }else {
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up")
                }
            }else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
        }
        
        // valid word
        gameState.usedWords.insert(lowerAnswer, at: 0)
        
        DispatchQueue.global().async { [weak self] in
            self?.saveGameState()
            
            DispatchQueue.main.async {
                // could have just called tableView.reloadData() but then the insertion wouldn't have been animated
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        //make sure the title bar is not empty and is lower cased
        guard var tempWord = title?.lowercased()else{return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    
    
    func isOriginal(word: String) -> Bool {
        return !gameState.usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 || word == title {
            return false
        }else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameState.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = gameState.usedWords[indexPath.row]
        return cell
    }
    
    
    @objc func loadGameState() {
        let userDefaults = UserDefaults.standard
        if let loadedState = userDefaults.object(forKey: gameStateKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedState = try? decoder.decode(GameState.self, from: loadedState) {
                gameState = decodedState
            }
        }
        
        // no word found in gameState: start a new game
        if gameState.currentWord.isEmpty {
            performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
        }
        // otherwise, load data into view
        else {
            performSelector(onMainThread: #selector(loadGameStateView), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func saveGameState() {
        let encoder = JSONEncoder()
        if let encodedState = try? encoder.encode(gameState) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedState, forKey: gameStateKey)
        }
    }
    
    @objc func loadGameStateView() {
        title = gameState.currentWord
        tableView.reloadData()
    }
}


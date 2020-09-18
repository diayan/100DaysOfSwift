//
//  ViewController.swift
//  Guess The Flag
//
//  Created by diayan siat on 07/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button3: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button1: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0 //track correct answer
    var numberOfQuestions = 0
    var highestScore = 0
    var maxQuestions = 10 //max num of questions a player can answer
    var currentQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["Estonia", "France", "Germany", "Ireland",
                      "Italy", "Monaco", "Nigeria", "Poland", "Spain",
                      "UK", "US"]
        
        //five buttons a thin border width to differentiate them from the bg of the UI
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.white.cgColor
        button2.layer.borderColor = UIColor.white.cgColor
        button3.layer.borderColor = UIColor.white.cgColor
        
        let defaults = UserDefaults.standard
        highestScore = defaults.object(forKey: "HighestScore") as? Int ?? 0
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        currentQuestion += 1
        
        if currentQuestion > maxQuestions {
            showSpecialMessage()
            return
        }
        
        //Swift's built-in methods for in place shuffling arrays.
        countries.shuffle()
        //generate a randome number from 0-2 inclusive
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        //set the nav bar title to the name of the country
        title = countries[correctAnswer].uppercased() + " - Score: \(score)"

    }
    
    func showSpecialMessage() {
        var result = "Questions asked: \(maxQuestions) \nFinal: Score \(score)"
        
        var isHighestScoreSaved = false
        
        if score > highestScore {
            result += "\n\nNEW HIGH SCORE!\nPrevious high score: \(highestScore)"
            highestScore = score
            isHighestScoreSaved = true
        }
        
        let ac = UIAlertController(title: "End of the game", message: result, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart game", style: .default, handler: askQuestion))

            score = 0
            correctAnswer = 0
            currentQuestion = 0

            present(ac, animated: true)
            
            // project 12 challenge 2
            if isHighestScoreSaved {
                performSelector(inBackground: #selector(saveHighestScore), with: nil)
            }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            
        }else {
            title = "Wrong! That's the flag of \(countries[sender.tag])"
            score -= 1
        }
        
        numberOfQuestions += 1
        
        var alertMessage = "Your final score is "
        if numberOfQuestions == 10 {
            alertMessage = "Your final score is"
        }
        
        let alertAction = UIAlertController(title: title, message: "\(alertMessage) \(score)", preferredStyle: .alert)
        alertAction.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(alertAction, animated: true)
        
    }
    
    @objc func saveHighestScore() {
        let defaults = UserDefaults.standard
        defaults.set(highestScore, forKey: "HighestScore")
    }
}

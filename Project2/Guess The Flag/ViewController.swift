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
        
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
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
}


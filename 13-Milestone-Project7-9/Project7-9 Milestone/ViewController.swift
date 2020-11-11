//
//  ViewController.swift
//  Project7-9 Milestone
//
//  Created by diayan siat on 05/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func loadView() {
        super.loadView()
        
        self.addButtonsRows(startPosition: 0, maxCol: 6)
        self.addButtonsRows(startPosition: 6, maxCol: 7)
        self.addButtonsRows(startPosition: 13, maxCol: 6)
        self.addButtonsRows(startPosition: 19, maxCol: 7)
    }
    
    
    func addButtonsRows(startPosition: Int, maxCol: Int) {
        //this serves as a container to hold all the letter buttons
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        //        NSLayoutConstraint.activate([
        //
        //            buttonView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        //            buttonView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        //            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //            buttonView.widthAnchor.constraint(equalToConstant: 1/CGFloat(4)),
        //            buttonView.heightAnchor.constraint(equalToConstant: 250),
        //            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        //        ])
        
        buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 20).isActive = true



        let width = 100
        let height = 80
        
       
            for col in 0..<maxCol {
                
             for row in 0..<4  {
                    
                print(letters)
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                letterButton.setTitle(letters[row + col], for: .normal)
                letterButton.contentHorizontalAlignment = .center
                letterButton.contentVerticalAlignment = .center
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                //add letter buttons to container view, buttonView
                buttonView.addSubview(letterButton)
                
                letterButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
                letterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/CGFloat(maxCol)).isActive = true
                
                switch col {
                case 0:
                    letterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                    
                case maxCol - 1:
                    letterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                    fallthrough
                default:
                    letterButton.leadingAnchor.constraint(greaterThanOrEqualTo: letterButtons[startPosition + (col - 1)].trailingAnchor).isActive = true
                    
                }
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hangman"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(startNewGame))
    }
    
    @objc func showScore() {
        
    }
    
    @objc func startNewGame() {
        
    }
}


//
//  ViewController.swift
//  26-Project18
//
//  Created by diayan siat on 26/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this just prints a simple message
        print("I am inside the viewDidLoad() method")
        
        //this inserts a separator after each number
        print(1,2,3,4, separator: "-")
        
        //If you don’t want print() to insert a line break after every call, just write this:
        print("print some message", terminator: "")
        
        
        //assertions, which are debug-only checks that will force your app to crash if a specific condition isn't true. Assertions are disabled in release mode
        assert(1 == 1, "Math failure!")
        //assert(1 == 2, "Math failure!")
        
        
        //Breakpoints
        for i in 1...100 {
            print("Got number \(i)")
        }
    }
}


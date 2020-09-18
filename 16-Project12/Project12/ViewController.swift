//
//  ViewController.swift
//  Project12
//
//  Created by diayan siat on 12/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        
        
        //Writing to user defaults
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UserTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("Diayan Siat", forKey: "Name")//store strings
        defaults.set(Date(), forKey: "LastRun")//storing complex objects
        
        let array = ["jan", "feb", "mar", "apr", "may"]
        defaults.set(array, forKey: "SavedArray")//storing arrays
        
        let dict = ["Name": "Diayan", "Country": "Ghana"]
        defaults.set(dict, forKey: "SavedDict") //saving dictionaries
        
        
        /*Reading values from user defaults, when reading from user defaults, check the return value to ensure you know what you are getting
         
         integer(forKey:) returns an integer if the key existed, or 0 if not.
         
         bool(forKey:) returns a boolean if the key existed, or false if not.
         
         float(forKey:) returns a float if the key existed, or 0.0 if not.
         
         double(forKey:) returns a double if the key existed, or 0.0 if not.
         
         object(forKey:) returns Any? so you need to conditionally typecast it to your data type
         
         It's object(forKey:) that will cause you the most bother, because you get an optional object back. You're faced with two options, one of which isn't smart so you realistically have only one option!
         Your options:
         
         Use as! to force typecast your object to the data type it should be.
         Use as? to optionally typecast your object to the type it should be.
         
         If you use as! and object(forKey:) returned nil, you'll get a crash, using as? also requires using unwrapping the optional or create a default value
         */
        
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]() //if there is no array of strings, make a new array of strings
        
        let savedDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String : String]()
    }
}


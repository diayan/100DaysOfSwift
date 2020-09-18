//
//  Person.swift
//  Project10
//
//  Created by diayan siat on 05/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}

//When we were working on this code in project 10, there were two outstanding questions:
//
//1. Why do we need a class here when a struct will do just as well? (And in fact better, because structs come with a default initializer!)
//2. Why do we need to inherit from NSObject?

//It's time for the answers to become clear. You see, working with NSCoding requires you to use objects, or, in the case of strings, arrays and dictionaries, structs that are interchangeable with objects. If we made the Person class into a struct, we couldn't use it with NSCoding.
//
//The reason we inherit from NSObject is again because it's required to use NSCoding – although cunningly Swift won't mention that to you, your app will just crash.

//Once you conform to the NSCoding protocol, you'll get compiler errors because the protocol requires you to implement two methods: a new initializer and encode().
//
//irst, you'll be using a new class called NSCoder. This is responsible for both encoding (writing) and decoding (reading) your data so that it can be used with UserDefaults.

//
//  Person.swift
//  Project10
//
//  Created by diayan siat on 05/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

//
//  Photo.swift
//  Project1
//
//  Created by diayan siat on 12/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

class Photo: NSObject {
    var name: String
    var photo: String
    
    init(name: String, photo: String) {
        self.name = name
        self.photo = photo
    }
}

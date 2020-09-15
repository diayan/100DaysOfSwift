//
//  Photo.swift
//  Milestone-Projects10-12
//
//  Created by diayan siat on 13/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

class Photo: Codable {
    var fileName: String
    var caption: String
    
    init(fileName: String, caption: String) {
        self.fileName = fileName
        self.caption = caption
    }
}

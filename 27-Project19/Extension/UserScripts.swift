//
//  UserScripts.swift
//  Project19
//
//  Created by diayan siat on 04/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class UserScripts: Codable {

    var name: String
    var script: String
    
    
    init(name: String, script: String) {
        self.name = name
        self.script = script
    }
}

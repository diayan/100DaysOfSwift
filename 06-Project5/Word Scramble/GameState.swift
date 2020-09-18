//
//  GameState.swift
//  Word Scramble
//
//  Created by diayan siat on 13/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

struct GameState: Codable {
    var currentWord: String
    var usedWords: [String]
}

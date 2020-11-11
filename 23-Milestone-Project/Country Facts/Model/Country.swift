//
//  Country.swift
//  Country Facts
//
//  Created by diayan siat on 27/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

struct Country: Codable {
    let name: String
    let region: String
    let capital: String
    let borders: [String]
    let flag: String
    let alpha2Code: String
    let area: Double?
    let population: Double
    let currencies: [Currency]
    let languages: [Language]
    let nativeName: String
}

struct Language: Codable {
    let iso6391: String?
    let iso6392: String
    let name: String
    let nativeName: String
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name, nativeName
    }
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}




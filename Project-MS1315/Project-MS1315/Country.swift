//
//  Country.swift
//  Project-MS1315
//
//  Created by Chloe Fermanis on 19/9/21.
//

import Foundation

struct Country: Codable {
    
    let name: String
    let capital: String
    let region: String
    let population: Int
    let flag: URL?
    var currencies: [Currency]

}

struct Currency: Codable {
    
    let code: String?
    let name: String?
    let symbol: String?
    
}

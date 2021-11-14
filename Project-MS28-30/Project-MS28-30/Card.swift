//
//  Card.swift
//  Project-MS28-30
//
//  Created by Chloe Fermanis on 14/11/21.
//

import UIKit

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdetifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdetifier()
    }
}

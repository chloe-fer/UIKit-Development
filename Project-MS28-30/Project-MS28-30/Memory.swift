//
//  Memory.swift
//  Project-MS28-30
//
//  Created by Chloe Fermanis on 14/11/21.
//

import Foundation

class Memory {
    
    var cards = [Card]()
    
    var indexFaceUp: Int?
    
    func chooseCards(at index: Int) {
        
        if !cards[index].isMatched {
            
            if let matchIndex = indexFaceUp, matchIndex != index {
               
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexFaceUp = nil
                
            } else {
                
                // either no cards or two cards are face up - can't match
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexFaceUp = index
            }
            
        }

    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            // cards += [card, card]
            cards.append(card)
            cards.append(card)
        }
        cards = cards.shuffled()
        
    }
}

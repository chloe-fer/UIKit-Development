//
//  ViewController.swift
//  Project-MS28-30
//
//  Created by Chloe Fermanis on 13/11/21.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var flipLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    lazy var game = Memory(numberOfPairsOfCards: cardButtons.count / 2)

    var emojis = ["🤺", "🤼", "🧗", "🏄🏽‍♂️", "🧘🏽‍♂️", "🏇", "🏊🏽‍♂️", "🪂"]
    
    var emojiDictionary = [Int:String]()
    
    // "🧗", "🏄🏽‍♂️", "🧘🏽‍♂️", "🏇", "🏊🏽‍♂️", "🪂",
    
    var flipCount = 0 {
        didSet {
            flipLabel.text = "Flip Count: \(flipCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Memory"
    }


    @IBAction func cardPressed(_ sender: UIButton) {
        
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCards(at: cardNumber)
            updateGame()
        } else {
            print("the selected card is not in cardButtons")
        }
        
    }
    
//    func flipCard(withEmoji emoji: String, on button: UIButton) {
//
//        if button.currentTitle == emoji {
//            button.setTitle("", for: .normal)
//            button.backgroundColor = .gray
//        } else {
//            button.setTitle(emoji, for: .normal)
//            button.backgroundColor = .white
//        }
//    }
    
    func updateGame() {
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = .white
                
            } else {
                
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? .clear : .gray
            }
            
        }
        
    }
    
    func emoji(for card: Card) -> String {
        if emojiDictionary[card.identifier] == nil, emojis.count > 0 {
            let randomIndex = Int.random(in: 0...emojis.count-1)
            emojiDictionary[card.identifier] = emojis.remove(at: randomIndex)
        }
        return emojiDictionary[card.identifier] ?? "?"
    }

}


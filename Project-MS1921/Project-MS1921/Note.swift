//
//  Note.swift
//  Project-MS1921
//
//  Created by Chloe Fermanis on 9/10/21.
//

import Foundation

class Note: NSObject, Codable {
    
    var text: String
    var date: Date
    
    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}

let someDateTime = Date(timeIntervalSinceReferenceDate: -123456789.0)

let test = [Note(text: "Welcome to the house of fun. I'm not sure how to do this. I'm not sure how to do this. I'm not sure how to do this.", date: someDateTime),
        Note(text: "Remember these things.", date: someDateTime)]

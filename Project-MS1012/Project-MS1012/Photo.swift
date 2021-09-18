//
//  Photo.swift
//  Project-MS1012
//
//  Created by Chloe Fermanis on 7/9/21.
//

import UIKit

class Photo: NSObject, Codable {
    
    var name: String
    var caption: String
    
    init(name: String, caption: String) {
        self.name = name
        self.caption = caption
    }
        
}

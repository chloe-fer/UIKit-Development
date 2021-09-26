//
//  ViewController.swift
//  Project-18
//
//  Created by Chloe Fermanis on 25/9/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("I'm inside the viewDidLoad() method!")
        
        // print is a variadic function
        print(1,2,3,4,5)
        
        // eliminate line break after print
        print("WTF", terminator: "")

        print(1,2,3,4,5, separator: "-")
        
        // success does nothing
        assert(1 == 1, "Maths failure!")
        
        // assertion failure
        //assert(1 == 2, "Maths failure!")

        for i in 1 ... 100 {
            print("Number \(i)")
        }
    }


}


//
//  DetailViewController.swift
//  Project-MS1921
//
//  Created by Chloe Fermanis on 9/10/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var noteTextView: UITextView!
    
    var selectedNote: Note?
    
    var selectedTitle = ""
    var selectedText = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        selectedTitle = selectedNote?.title.uppercased() ?? "Unknown"
        selectedText = selectedNote?.text ?? ""
        
//        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20)]
//        let attributedString = NSAttributedString(string: selectedTitle, attributes: attributes)
//        noteTextView.attributedText = attributedString
        
        noteTextView.text = selectedTitle + "\n\n" + selectedText
        
        // Do any additional setup after loading the view.
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        noteTextView.scrollIndicatorInsets = noteTextView.contentInset

        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

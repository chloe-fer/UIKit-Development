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
    var notes: [Note]?
    var selectedIndex: Int?

        
    var selectedText = ""
    
    var share: UIBarButtonItem!
    var trash: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        selectedText = selectedNote?.text ?? ""
        
//        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20)]
//        let attributedString = NSAttributedString(string: selectedTitle, attributes: attributes)
//        noteTextView.attributedText = attributedString
        
        noteTextView.text = selectedText
        

        // tab bar
        
        
        trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [trash, spacer, share]
        trash.tintColor = .systemPink
        share.tintColor = .systemPink

        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func trashTapped() {
        
        guard let index = selectedIndex else {
            print("No index found.")
            return
        }
        notes?.remove(at: index)
        
        saveNotes()
    
        navigationController?.popViewController(animated: true)

    }
    
    @objc func shareTapped() {
        
        guard let note = selectedNote?.text else {
            print("No note found.")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = share
        present(vc, animated: true)
    }
    
    // done button
    @objc func doneTapped() {
    
        selectedNote?.text = String(noteTextView.text)
        // save note
        saveNotes()
        
        // go back to ViewController
        navigationController?.popViewController(animated: true)
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
    
    func saveNotes() {
            
        let jsonEncoder = JSONEncoder()
        if let savedNote = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNote, forKey: "SavedNotes")
            
        } else {
            print("Failed to save note.")
        }
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

//
//  ActionViewController.swift
//  Extension
//
//  Created by Chloe Fermanis on 27/9/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(optionAlert))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            
                if let itemProvider = inputItem.attachments?.first {
                    
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                        
                        // do stuff!
                        
                        guard let itemDictionary = dict as? NSDictionary else { return }
                        
                        guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                        
                        //print(javaScriptValues)
                        
                        self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                        
                        self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            
                            self?.title = self?.pageTitle
                            
                        }
                    
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // Day 69 - Challenge 1: use UIAlertController to allow users to select prewritten example scripts
    @objc func optionAlert() {
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Examples", style: .default, handler: examples))
        ac.addAction(UIAlertAction(title: "Load", style: .default, handler: examples))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func save(action: UIAlertAction) {
        
    }
    
    func examples(action: UIAlertAction) {
        
        let ac = UIAlertController(title: "Example Scripts", message: nil, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Title", style: .default, handler: { action in
            self.script.text = "alert(document.title);"
        
        }))
        ac.addAction(UIAlertAction(title: "URL", style: .default, handler: { action in
            self.script.text = "alert(document.URL);"
        
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)

        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}

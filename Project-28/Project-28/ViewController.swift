//
//  ViewController.swift
//  Project-28
//
//  Created by Chloe Fermanis on 4/11/21.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    var hasPassword = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Nothing To See Here"
        
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
        
    func unlockSecretMessage() {
        
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        // Challenge 1: Add Done button to navigation bar to re-lock the app (only show when the app is unlocked).
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
    }
    
    @objc func saveSecretMessage() {
        
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        
        secret.resignFirstResponder()    // focus is not on the text view.
        secret.isHidden = true
        
        // Challenge 1: Add Done button to navigation bar to re-lock the app (only show when the app is unlcoked).
        navigationItem.rightBarButtonItem = nil
        
        title = "Nothing To See Here"
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // See Project 19
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

            if notification.name == UIResponder.keyboardWillHideNotification {
                secret.contentInset = .zero
            } else {
                secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            }

            secret.scrollIndicatorInsets = secret.contentInset

            let selectedRange = secret.selectedRange
            secret.scrollRangeToVisible(selectedRange)
    }

    @IBAction func authenticateTapped(_ sender: UIButton) {
        
        let context = LAContext()
        var error: NSError?
        
        // can we use biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [ weak self ] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error - failed authentication
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometric authentication
            //let ac = UIAlertController(title: "Biometry Unavaileble", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            
            
            if hasPassword {
                
                // Challenge 2: create a password system
                let ac = UIAlertController(title: "Biometry Unavailable", message: "Please enter your password.", preferredStyle: .alert)
                ac.addTextField()
                let passwordAction = UIAlertAction(title: "OK", style: .default) { [ unowned ac ] _ in
                    if let password =                     KeychainWrapper.standard.string(forKey: "Password") {
                        if password == ac.textFields?[0].text {
                            self.unlockSecretMessage()
                        } else {
                            self.noMatchPassword()
                        }
                    }
                    
                }
                ac.addAction(passwordAction)
                ac.addAction(UIAlertAction(title: "Cancel", style: .default))
                present(ac, animated: true)
                
            } else {
                
                let ac = UIAlertController(title: "Set Password", message: "", preferredStyle: .alert)
                ac.addTextField()
                let textFieldAction = UIAlertAction(title: "OK", style: .default) { [ unowned ac ] _ in
                    let password = ac.textFields?[0].text ?? "1234"
                    KeychainWrapper.standard.set(password, forKey: "Password")
                    self.hasPassword = true
                }
                ac.addAction(textFieldAction)
                present(ac, animated: true)
            }

        }
    }
    
    func noMatchPassword() {
        let ac = UIAlertController(title: "Password is Incorrect", message: "Password does not match.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}


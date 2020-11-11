//
//  ViewController.swift
//  Project28
//
//  Created by diayan siat on 04/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!
    var doneButton: UIBarButtonItem!
    var passwordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveSecretMessage))
        passwordButton = UIBarButtonItem(title: "Password", style: .plain, target: self, action: #selector(inputPassword))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func inputPassword() {
        let ac = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        
        let context = LAContext() //local contentication
        var error: NSError? //stores errors that are returned if any
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
        
            //anytime we do a weak self in a closure, it means we want to have access to self safely in the closure
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    }else{
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be authenticated, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        }else{
            let ac = UIAlertController(title: "Biometric unavailable", message: "Your device is not configured for biometric identification", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        }else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = passwordButton
        //read the user's saved string from the key chain
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
        
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
}


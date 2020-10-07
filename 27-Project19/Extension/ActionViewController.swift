//
//  ActionViewController.swift
//  Extension
//
//  Created by diayan siat on 29/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, LoaderDelegate {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var savedScriptByURL = [String : String]()
    var savedScriptByURLKey = "SavedScriptByURL"
    var savedScriptsByName = [UserScripts]()
    var savedScriptByNameKey = "SavedScriptKey"
    
    var scriptToLoad: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarksTapped))
        
        //hardware keyboard handler. This can be used in handling the keyboard in every case. Made by Paul
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use. We only care about this first item in this project, and even then it might not exist, so we conditionally typecast using if let and as?.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            //Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
            if let itemProvider = inputItem.attachments?.first {
                //The next line uses loadItem(forTypeIdentifier: ) to ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [ weak self ] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {
                        return
                    }
                    
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    self?.loadData()
                    
                    DispatchQueue.main.async {
                        self?.updateUI()
                    }
                }
            }
        }
    }
    
    //load saved data
    @objc func loadData() {
        let userDefaults = UserDefaults.standard
        savedScriptByURL = userDefaults.object(forKey: savedScriptByNameKey) as? [String : String] ?? [String : String]()
        
        if let savedScriptsByNameData = userDefaults.object(forKey: savedScriptByNameKey) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                savedScriptsByName = try jsonDecoder.decode([UserScripts].self, from: savedScriptsByNameData)
            }catch {
                print("Failed to load data")
            }
        }
    }
    
    //update the ui
    func updateUI()  {
        
        title = "Script Injection"
        
        //challenge 2
        if let url = URL(string: pageURL) {
            if let host = url.host {
                script.text = savedScriptByURL[host]
            }
            
        }
    }
    
    //challenge 3
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let scriptToLoad = scriptToLoad {
            script.text = scriptToLoad
        }
        scriptToLoad = nil
    }
    
    // challenges 1 and 3
    @objc func bookmarksTapped() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Save Scripts", style: .default, handler: {[weak self ] _ in
            self?.saveTapped()
            }
        ))
        
        ac.addAction(UIAlertAction(title: "Load Scripts", style: .default, handler: {[weak self ] _ in
            self?.loadTapped()
        }))
        
        ac.addAction(UIAlertAction(title: "Examples", style: .default, handler: {[weak self] _ in
            self?.exampleTapped()
        }))
        present(ac, animated: true)
    }
    
    //examaples of scripts on that a user can choose from
    func exampleTapped() {
        let ac = UIAlertController(title: "Examples", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        for(title, example) in scriptExamples {
            ac.addAction(UIAlertAction(title: title, style: .default){ [weak self ] _ in
                self?.script.text = example
            })
        }
        present(ac, animated: true)
    }
    
    //challenge 3
    func saveTapped() {
        let ac = UIAlertController(title: "Script Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.savedScriptsByName.append(UserScripts(name: name, script: self?.script.text ?? ""))
            
            //saving data in the background
            self?.performSelector(inBackground: #selector(self?.saveScriptByName), with: nil)
        })
        
        present(ac, animated: true)
    }
    
    //challenge 3
    func loadTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "LoadViewController") as? LoaderTableViewController {
            vc.saveScriptsByName = savedScriptsByName
            vc.saveScriptsByNameKey = savedScriptByNameKey
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //save the script by name using user defaults: it will run in the background thread
    @objc func saveScriptByName() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(savedScriptsByName) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scripts")
        }else {
            print("Failed to save data")
        }
    }
    
    //challenge 3
    func loader(_ loader: LoaderTableViewController, didSelect scripts: String) {
        scriptToLoad = scripts
    }
    
    //challenge 3
    func loader(_ loader: LoaderTableViewController, didUpdate scripts: [UserScripts]) {
        savedScriptsByName = scripts
    }
    
    //
    @IBAction func done() {
        
        DispatchQueue.global().async { [ weak self ] in
            self?.saveScriptForCurrentUrl()
            
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": self?.script.text as? Any]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            
            DispatchQueue.main.async {
                self?.extensionContext?.completeRequest(returningItems: [item])
            }
        }
    }
    
    //challenge 2
    //save scripts for the current url
    func saveScriptForCurrentUrl() {
        let url = URL(string: pageURL)
        
        if let host = url?.host {
            savedScriptByURL[host] = script.text
            let userDefaults = UserDefaults.standard
            
            userDefaults.set(savedScriptByURL, forKey: savedScriptByURLKey)
        }
    }
    
    //handling keyboard for any UI
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //cgRectValue tells the size of the keyboard, this means keyboardScreenEndFrame holds that size
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        //we convert the rectangle value to our view's co-ordinates. This is because rotation isn't factored into the frame, so if the user is in landscape we'll have the width and height flipped – using the convert() method will fix that
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            //textview should take up all availble space
            script.contentInset = .zero
        }else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        //make textview scroll down to show what ever the user has just tapped on
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}

//examples of scripts that a user can choose from
let scriptExamples = [
    (title: "Display an alert",
     example: """
    alert("Page title: " + document.title + "\\nPage url: " + document.URL);
    """
    ),
    (title: "Replace page content",
     example: """
    document.body.innerHTML = '';
    let p = document.createElement('p');
    p.textContent = 'Page content replaced!';
    document.body.appendChild(p);
    """
    ),
    (title: "Split URL",
     example: """
    alert("Protocol: " + window.location.protocol + "\\nHost: " + window.location.host + "\\nPathname: " + window.location.pathname);
    """
    )
]

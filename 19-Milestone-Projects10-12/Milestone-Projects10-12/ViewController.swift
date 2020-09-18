//
//  ViewController.swift
//  Milestone-Projects10-12
//
//  Created by diayan siat on 13/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFiles))
        
        let defaults = UserDefaults.standard
        
        if let savedFiles = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedFiles)
            }catch {
                print("Failed to load people")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoTableViewCell else {
            fatalError("Unable to deque photo cell")
        }
        
        let photo = photos[indexPath.row]
        cell.name.text = photo.caption
        let path = getDocumentsDirectory().appendingPathComponent(photo.fileName)
        cell.photoImageView.image = UIImage(contentsOfFile: path.path)
        cell.photoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.photoImageView.layer.borderWidth = 2
        cell.photoImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        self.saveFiles()
        return cell
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString //use this to generate unique numbers for your images
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(fileName: imageName, caption: "Unknown")
        photos.append(photo)
        tableView.reloadData()
        self.saveFiles()
        dismiss(animated: true)
    }
    
    @objc func addNewFiles() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            picker.sourceType = .camera
            present(picker, animated: true)
        }else {
            present(picker, animated: true)
        }
    }
    
    func saveFiles() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        }else {print("Failed to save data")}
    }
}


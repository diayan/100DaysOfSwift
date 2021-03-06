//
//  DetailViewController.swift
//  Project1
//
//  Created by diayan siat on 05/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var pictureCount: Int?
    var pictureNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title to scene in the navigation controller
        title = "Picture \(pictureNumber!) of \(pictureCount!)"
        
        //never use large titles in this scene
        navigationItem.largeTitleDisplayMode = .never
        
        //checks that selected image is not empty if it is, break
        //assert(!selectedImage!.isEmpty, "Selected image is empty")
        
        //load seleted image into imageview if it is not nil
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    //show navigation bars when you tap on picture in detail view
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }
    
    //hide navigation bars when you tap on the picture
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
    }
    */

}

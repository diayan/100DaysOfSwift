//
//  ViewController.swift
//  Project13
//
//  Created by diayan siat on 15/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var changeFilter: UIButton!
    @IBOutlet var pixellate: UISlider!
    @IBOutlet var distort: UISlider!
    @IBOutlet var blur: UISlider!
    
    var context: CIContext! //core image context: a component that handles rendering
    var currentFilter: CIFilter! //stores whatever filter the user activates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.alpha = 0
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        changeFilter.setTitle("CISepiaTone", for: .normal)
        //initializing
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone") //CISepiaTone is one of the filters
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage) //CIImage is the CoreImage equivalent of UIImage but more complex
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing(tag: nil)
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController{
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
        
    }
    
    func setFilter(action: UIAlertAction) {
        changeFilter.setTitle(action.title, for: .normal)
        guard currentImage != nil else {return}
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing(tag: nil)
        
    }
    @IBAction func save(_ sender: Any) {
        
        let ac = UIAlertController(title: "Error", message: "Select an image to apply filters", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        
        guard let image = imageView.image else {return}
        
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_ :didFinishSavingWithError: contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing(tag: sender.tag)
    }
    
    func applyProcessing(tag: Int?)  {
        let inputKeys = currentFilter.inputKeys
        
        //uses the value of our intensity slider to set the kCIInputIntensityKey value of our current Core Image filter
        
        switch tag {
        case 0:
            if inputKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
            }
        case 1:
            if inputKeys.contains(kCIInputRadiusKey) {
                      currentFilter.setValue(blur.value * 200, forKey: kCIInputRadiusKey)
                  }
        case 2:
            if inputKeys.contains(kCIInputScaleKey) {
                       currentFilter.setValue(pixellate.value * 10, forKey: kCIInputScaleKey)
                   }
        case 3:
            if inputKeys.contains(kCIInputCenterKey) {
                      currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
                  }
        default:
            print("No effect available")
        }
        
        //First line safely reads the output image from our current filter
        guard let outputImage = currentFilter.outputImage else {return}
        
        
        //creates a new data type called CGImage from the output image of the current filter. returns an optional CGImage so we need to check and unwrap with if let.
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            //creates a new UIImage from the CGImage
            let processedImage = UIImage(cgImage: cgImage)
            //assigns that UIImage to our image view.
            imageView.image = processedImage
        }
        
        imageView.alpha = 1
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        }else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        }
    }
}


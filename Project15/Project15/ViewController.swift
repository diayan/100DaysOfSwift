//
//  ViewController.swift
//  Project15
//
//  Created by diayan siat on 20/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin")) //load penguin image into the imageview
        imageView.center = CGPoint(x: 512, y: 384) //center imageview at the specified position
        view.addSubview(imageView)
    }
    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true //hide button when it is tapped
        
//        UIView.animate(withDuration: 1, delay: 0, options:[], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2) //make the view 2x its default size
            case 1:
                self.imageView.transform = .identity //clears our view of any predefined transform sets it back to its initial size
            case 2:
//  CGAffineTransform that takes X and Y values for its parameters. These values are deltas, or differences from the current value, meaning that the above code subtracts 256 from both the current X and Y position
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                
            case 3:
                self.imageView.transform = .identity
                
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                
            case 5:
                self.imageView.transform = .identity
                
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
                
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
                
            default:
                break
            }
            
        }) { finished in
            sender.isHidden = false //once the animation is finised, show button
            
            //this completion closure detects when an animation is over and calls its code
        }
        currentAnimation += 1
        if currentAnimation > 7 {
            //the value of current animation should never exceed 7, if it does, reset it to 0
            currentAnimation = 0
        }
    }
    

}


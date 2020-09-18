//
//  ViewController.swift
//  Project6b
//
//  Created by diayan siat on 20/08/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating ui in code
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false //this says don't make constraints for me, I'll do it myself
        label1.backgroundColor = .red
        label1.text = "THESE"
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "ARE"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .orange
        label5.text = "LABEL"
        label5.sizeToFit()
        
        //addsubview lets us add the views to our screen
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        
        //
        //        //visual format language a way to draw the layout you want with series of keyboard symbols
        //        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        //
        //        for label in viewsDictionary.keys {
        //            //addConstraints adds an array of constraints to our VC's View
        //            //NSLayoutConstraint.constraints converts visual format language into an array of constraints
        //            //H:|[\(label)]|, H: -> Horizontal layout, | -> the edge of the view and putting it in brackets is a visual way of saying where to put the label
        //                 view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        //        }
        //
        //        let metrics = ["labelHeight": 88]
        //
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        //    }
        
        
        
        var previous: UILabel?
//
//                for label in [label1, label2, label3, label4, label5] {
//                    label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//                    label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//
//                    if let previous = previous {
//                        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//                    }else{
//                        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//                    }
//                    previous = label
//                }
//
        
        //CHALLENGE ONE
        //        for label in [label1, label2, label3, label4, label5] {
        //
        ////            replacing the widthAnchor of our labels with leadingAnchor and trailingAnchor constraints, which more explicitly pin the label to the edges of its parent.
        //
        //            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //
        //            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
        //
        //            if let previous = previous {
        //                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
        //            }else{
        //                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        //            }
        //            previous = label
        //        }
        
        
        
        //CHALLENGE TWO : NB. labels won't go to safe area
//
//        for label in [label1, label2, label3, label4, label5] {
//
//            //  replacing the widthAnchor of our labels with leadingAnchor and trailingAnchor constraints, which more explicitly pin the label to the edges of its parent.
//
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//
//            if let previous = previous {
//                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//                label.leadingAnchor.constraint(equalTo: previous.leadingAnchor, constant: 0).isActive = true
//                label.trailingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 0).isActive = true
//            }else{
//                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//                label.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
//                label.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
//            }
//            previous = label
//        }
        
        
//        //CHALLENGE THREE
//        // Try making the height of your labels equal to 1/5th of the main view, minus 10 for the spacing. This is a hard one, but I’ve included hints below!
        for label in [label1, label2, label3, label4, label5] {

            //label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: 0).isActive = true
//
//            let constraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0)
//            self.view.addConstraint(constraint)

            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true

                label.leadingAnchor.constraint(equalTo: previous.leadingAnchor, constant: 0).isActive = true
                label.trailingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 0).isActive = true
            }else{
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true

                label.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
                label.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
            }
            previous = label
        }
    }
}


//
//  ViewController.swift
//  Project27
//
//  Created by diayan siat on 02/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawChecker()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        default:
            break
        }
    }
    
    //Rectangles
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            //drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 20, dy: 20)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    //Ellipses
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))//canvas on which we will draw
        
        let image = renderer.image { ctx in
            //drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 20, dy: 20)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    //Checkers
    func drawChecker() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for col in 0..<8 {
                    if(row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    //Transforms
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations) //number or amount of rotations is pi divided by rotations
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    //Lines
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi/2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                }else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = image
    }
    
    //Ellipses
      func drawEmoji() {
        
        let leftEyeStart: CGFloat = 40
        let eyeTopMargin: CGFloat = 50
        let rightEyeStart: CGFloat = 85
        let rightEyeTopMargin: CGFloat = 0

        
          let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))//canvas on which we will draw
          
          let image = renderer.image { ctx in
            
            //Draw face
              let face = CGRect(x: 0, y: 0, width: 200, height: 200).insetBy(dx: 20, dy: 20)
              ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
              ctx.cgContext.setStrokeColor(UIColor.systemYellow.cgColor)
              ctx.cgContext.setLineWidth(2)
              ctx.cgContext.addEllipse(in: face)
              ctx.cgContext.drawPath(using: .fillStroke)
            
            //Draw left eye
            let leftEye = CGRect(x: 0, y: 0, width: 35, height: 50)
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.translateBy(x: leftEyeStart, y: eyeTopMargin)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fill)
            
            //Draw right eye
            let rightEye = CGRect(x: 0, y: 0, width: 35, height: 50)
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.translateBy(x: rightEyeStart, y: rightEyeTopMargin)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fill)
            
            //Draw a mouth
            let length: CGFloat = 80
            let mouthPosition: CGFloat = 50
            ctx.cgContext.rotate(by: .pi/2)
            ctx.cgContext.move(to: CGPoint(x: length, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: length, y: mouthPosition))
            ctx.cgContext.setStrokeColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.strokePath()
          }
          
          imageView.image = image
      }
    
    //draw Twin
    func drawTwin() {
        
    }
    
}


//
//  ViewController.swift
//  Project-27
//
//  Created by Chloe Fermanis on 30/10/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: UIButton) {
        
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        currentDrawType = 7
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            // Challenge 1
            drawEmoji()
        case 7:
            // Challenge 2
            drawTwin()
        default:
            break
        }
    }
    
    func drawRectangle() {
        
        // height/width - points not pixels
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        
        // height/width - points not pixels
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image

    }
    
    func drawCheckerboard() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            
            // drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    // if (row + col).isMultiple(of: 2) {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
            // use fill instrad of:
            //ctx.cgContext.addRect(rectangle)
            //ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        
        // height/width - points not pixels
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            // drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))

            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = image
        
    }
    
    func drawLines() {
        
        
        // height/width - points not pixels
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
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
    
    // Challenge 1: Draw and emoji
    func drawEmoji() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            let face = CGRect(x: 50, y: 50, width: 400, height: 400).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.addEllipse(in: face)
            ctx.cgContext.drawPath(using: .fill)
            
            let leftEye = CGRect(x: 130, y: 160, width: 100, height: 100)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftPupil = CGRect(x: 160, y: 160, width: 40, height: 40)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: leftPupil)
            ctx.cgContext.drawPath(using: .fill)


            let rightEye = CGRect(x: 280, y: 160, width: 100, height: 100)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let rightPupil = CGRect(x: 310, y: 160, width: 40, height: 40)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: rightPupil)
            ctx.cgContext.drawPath(using: .fill)

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(8)

            ctx.cgContext.move(to: CGPoint(x: 200, y: 350))
            ctx.cgContext.addLine(to: CGPoint(x: 300, y: 350))
            ctx.cgContext.drawPath(using: .fillStroke)

        }

        imageView.image = image

    }
    
    func drawTwin() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            ctx.cgContext.move(to: CGPoint(x: 60, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 200))
            
            ctx.cgContext.move(to: CGPoint(x: 75, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: 250))
            
            ctx.cgContext.move(to: CGPoint(x: 100, y: 200))

            ctx.cgContext.addLine(to: CGPoint(x: 110, y: 250))
            ctx.cgContext.move(to: CGPoint(x: 110, y: 250))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 200))
            ctx.cgContext.move(to: CGPoint(x: 120, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 130, y: 250))
            ctx.cgContext.move(to: CGPoint(x: 130, y: 250))
            ctx.cgContext.addLine(to: CGPoint(x: 140, y: 200))

            ctx.cgContext.move(to: CGPoint(x: 150, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 150, y: 250))
            
            ctx.cgContext.move(to: CGPoint(x: 160, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 250))
            ctx.cgContext.move(to: CGPoint(x: 160, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 250))
            ctx.cgContext.move(to: CGPoint(x: 180, y: 250))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 200))







            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image

    }
    
}


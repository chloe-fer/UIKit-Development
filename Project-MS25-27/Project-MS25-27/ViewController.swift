//
//  ViewController.swift
//  Project-MS25-27
//
//  Created by Chloe Fermanis on 1/11/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var importButton: UIButton!
    @IBOutlet var topTextButton: UIButton!
    @IBOutlet var bottomTextButton: UIButton!
    
    var memeImage: UIImage?
    var topText = ""
    var bottomText = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Memes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))

    }
    
   
    @objc func shareMeme() {
        
    }
    
    @objc func addMeme() {
        let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //let size = imageView.frame.size

        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let img = renderer.image { ctx in
                        
            memeImage = image
            memeImage?.draw(at: CGPoint(x: 0, y: 0))
            
        }
        imageView.image = img
        
        dismiss(animated: true)
    }
    
    @IBAction func addTopText(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Add Top text", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let okAction = UIAlertAction(title: "OK", style: .default) { [self,  unowned ac ] _ in
            guard let text = ac.textFields?[0].text else { return }
            topText = text
                            
            let renderer = UIGraphicsImageRenderer(size: memeImage!.size)
            
            let img = renderer.image { ctx in
                                
                self.memeImage?.draw(at: CGPoint(x: 0, y: 0))
                
                writeText(text: topText, position: CGRect(x: 0, y: 64, width: self.memeImage!.size.width, height: 150))
                
            }
            self.imageView.image = img

        }
        
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
        
    }
    
    
    @IBAction func addBottomText(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Add Bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let okAction = UIAlertAction(title: "OK", style: .default) { [self,  unowned ac ] _ in
            guard let text = ac.textFields?[0].text else { return }
            self.bottomText = text
            
            let renderer = UIGraphicsImageRenderer(size: self.memeImage!.size)
            
            let img = renderer.image { ctx in
                                
                self.memeImage?.draw(at: CGPoint(x: 0, y: 0))

                self.writeText(text: self.topText, position: CGRect(x: 0, y: 64, width: self.memeImage!.size.width, height: 150))

                self.writeText(text: self.bottomText, position: CGRect(x: 0, y: self.memeImage!.size.height - 150, width: self.memeImage!.size.width, height: 150))

            }
            self.imageView.image = img

        }
        
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)

    }
    
    func writeText(text: String, position: CGRect) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attrs: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 100),
                    .paragraphStyle: paragraphStyle
                ]
        let attributedString = NSAttributedString(string: text, attributes: attrs)
            
        attributedString.draw(with: position, options: .usesLineFragmentOrigin, context: nil)
        

    }
    
    

    
}


//
//  ViewController.swift
//  Project-MS1012
//
//  Created by Chloe Fermanis on 7/9/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photos = [Photo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Photo Picker"
        
        //let defaults = UserDefaults.standard
        //photos = defaults.object(forKey: "SavedPhotos") as? [Photo] ?? [Photo]()
        
        let defaults = UserDefaults.standard

        if let savedPhotos = defaults.object(forKey: "SavedPhotos") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photo")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPhoto))
    }
    
    @objc func addNewPhoto() {
        
        let picker = UIImagePickerController()
        //picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Something went very wrong")
        }
        
        let photo = photos[indexPath.row]
        
        // display caption
        cell.photoCaption.text = photo.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.name)
        cell.photoView?.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            let path = getDocumentsDirectory().appendingPathComponent(photos[indexPath.row].name)

            
            vc.selectedImage = path.path
            vc.title = photos[indexPath.row].caption
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(name: imageName, caption: "New Photo")
        photos.append(photo)
        
        dismiss(animated: true)

        let ac = UIAlertController(title: "Caption", message: "Provide a caption for your photo.", preferredStyle: .alert)
        ac.addTextField()
        let okAction = UIAlertAction(title: "OK", style: .default) { [ weak self, weak ac] _ in
            
            let answer = ac?.textFields![0].text
            photo.caption = answer ?? "New photo"
            self?.tableView.reloadData()

        }
        ac.addAction(okAction)
        present(ac, animated: true)
         
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "SavedPhotos")
        } else {
            print("Failed to save photo.")
        }
    }
    
}


//
//  ViewController.swift
//  Project-MS1921
//
//  Created by Chloe Fermanis on 9/10/21.
//

import UIKit

class ViewController: UITableViewController {

    // let notes = [Note]()
    
    var notes = test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(notes.count) Notes"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func createNote() {
        
        notes.append(Note(title: "Unknow", text: "", date: Date()))
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteCell
        
        let currentNote = notes[indexPath.row]
        
        cell.title?.text = currentNote.title.uppercased()
        
        let today = notes[indexPath.row].date
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
        
        cell.currentDate?.text = dateToString(currentDate: today)
        cell.noteText.text = currentNote.text
        return cell
    }
    
    
    func dateToString(currentDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: currentDate)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedNote = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


}


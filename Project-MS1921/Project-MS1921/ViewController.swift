//
//  ViewController.swift
//  Project-MS1921
//
//  Created by Chloe Fermanis on 9/10/21.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {

    var notes = [Note]()
        
    var text: UIBarButtonItem!
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false

        title = "Notes"
    
        // search bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
                
        // tool bar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        
        text = UIBarButtonItem(title: "\(notes.count) Notes", style: .plain, target: nil, action: nil)
        
        toolbarItems = [spacer, text, spacer, compose]
        
        text.tintColor = .systemPink
        compose.tintColor = .systemPink
        
        navigationController?.isToolbarHidden = false
                
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
        text.title = "\(notes.count) Notes"
        tableView.reloadData()
    }
    
    
    @objc func createNote() {
        
        notes.append(Note(text: "", date: Date()))
        
        // insert at the front of the array
        //notes.insert(Note(text: "", date: Date()), at: 0)

        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedNote = notes[notes.count-1]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteCell
        
        let currentNote = notes[indexPath.row]
                
        if currentNote.text == "" {
            cell.title?.text = "UNTITLED"
        } else {
            let splitNote = currentNote.text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
            cell.title?.text = String(splitNote[0]).uppercased()
            if splitNote.count > 1 {
                cell.noteText.text = String(splitNote[1])
            } else {
                cell.noteText.text = String(splitNote[0])
            }
        }
        let today = notes[indexPath.row].date
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
        
        cell.currentDate?.text = dateToString(currentDate: today)
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
            vc.notes = notes
            vc.selectedIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // delete note
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                saveNotes()
            }
        }
    
    func loadNotes() {
        
        let defaults = UserDefaults.standard

        if let savedNotes = defaults.object(forKey: "SavedNotes") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }

        }
    }
    
    func saveNotes() {
        
        let jsonEncoder = JSONEncoder()
        if let savedNote = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNote, forKey: "SavedNotes")
            
        } else {
            print("Failed to save note.")
        }

    }


}


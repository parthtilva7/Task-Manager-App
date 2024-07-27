//
//  TodoViewController.swift
//  Task Manager
//
//  Created by Parth Tilva on 2024-04-10.
//

import UIKit
import Firebase

class TodoViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var items: [ItemToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaultItems()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        do {
                    try Auth.auth().signOut()
                    
            self.performSegue(withIdentifier: "logOutDone", sender: self)
                } catch let signOutError as NSError {
                    print("Error signing out:", signOutError)
                }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task To Do", message: "Enter Title or Description for Todo items", preferredStyle: .alert)
        alertController.addTextField(){textField in textField.placeholder = "Enter Task Type"}
        alertController.addTextField(){textField in textField.placeholder = "Name of Task"}
        alertController.addTextField(){textField in textField.placeholder = "Status "}
        alertController.addTextField(){textField in textField.placeholder = "Assigne"}
        alertController.addTextField(){textField in textField.placeholder = "Date"}
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let titleTextField = alertController.textFields?[0], let descriptionTextField = alertController.textFields?[1],
               let statusTextField = alertController.textFields?[2],
               let assigneTextField = alertController.textFields?[3],
               let dateTextField = alertController.textFields?[4]{
                let title = titleTextField.text ?? ""
                let description = descriptionTextField.text ?? ""
                let date = dateTextField.text ?? ""
                let assigne = assigneTextField.text ?? ""
                let status = statusTextField.text ?? ""
                
                
                
                let item = ItemToDo(title: title, description: description, status:status, date:date, assigne:assigne )
                self.items.append(item)
                self.tableView.reloadData()
            }
        }))
        self.present(alertController, animated: true)
    }
    private func loadDefaultItems(){
        
    }
    
    
}

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = "\(item.assigne) on \(item.date)"
        
        let typeSymbols: [String: String] = [
                "Authentication": "lock.fill",
                "List": "pencil.and.list.clipboard",
                "Navigation": "map.circle",
                "Networking": "network",
                "Persistence": "accessibility",
                "Meeting": "person.2.fill",
                "Design": "pencil.line",
                "Debugging": "hand.point.up.braille.fill",
                "Testing": "checkmark.circle",
                "Deliverable": "filemenu.and.selection"
            ]
        if let symbol = typeSymbols[item.title]{
            content.image = UIImage(systemName: symbol)
        }else{
            content.image = UIImage(systemName: "list.bullet.below.rectangle")
        }
        
        switch item.status{
        case "Completed":
            let style = UIImage.SymbolConfiguration(paletteColors: [.systemGreen])
            let editedImage = content.image?.withConfiguration(style)
            content.image = editedImage
            
        case "In Progress":
            let style = UIImage.SymbolConfiguration(paletteColors: [.systemOrange])
            let editedImage = content.image?.withConfiguration(style)
            content.image = editedImage
            
        default:
            let style = UIImage.SymbolConfiguration(paletteColors: [.systemRed])
            let editedImage = content.image?.withConfiguration(style)
            content.image = editedImage
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        
        print(selectedItem)
        
        let actionSheet = UIAlertController(title: "", message: "Title: \(selectedItem.title)\nDescription: \(selectedItem.description)", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            
            self.performSegue(withIdentifier: "viewDetails", sender: selectedItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(updateAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension TodoViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetails", let selectedItem = sender as? ItemToDo {
            if let details = segue.destination as? DetailsViewController {
                details.selectedItem = selectedItem
                details.delegate = self
            }
        }
    }
}
extension TodoViewController: DetailsViewControllerDelegate {
    func didUpdateItem(_ item: ItemToDo) {
        if let index = items.firstIndex(where: { $0.title == item.title }) {
            items[index] = item
            tableView.reloadData()
        }
    }
}

struct ItemToDo{
        var title: String
        var description: String
        var status: String
        var date: String
        var assigne: String
}

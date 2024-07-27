//
//  DetailsViewController.swift
//  Task Manager
//
//  Created by Parth Tilva on 2024-04-10.
//

import UIKit
import Firebase

protocol DetailsViewControllerDelegate: AnyObject {
    func didUpdateItem(_ item: ItemToDo)
}

class DetailsViewController: UIViewController {
    var selectedItem: ItemToDo!
    weak var delegate: DetailsViewControllerDelegate?
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var taskStatus: UITextField!
    
    @IBOutlet weak var taskAssigne: UITextField!
    @IBOutlet weak var taskDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        taskName.text = selectedItem.title
        taskDescription.text = selectedItem.description
        taskStatus.text = selectedItem.status
        taskAssigne.text = selectedItem.assigne
        taskDate.text = selectedItem.date
    }
    
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard var selectedItem = selectedItem else {
            return
        }
        
        if let title = taskName.text,
           let description = taskDescription.text,
           let status = taskStatus.text,
           let assignee = taskAssigne.text,
           let date = taskDate.text {
            
            selectedItem.title = title
            selectedItem.description = description
            selectedItem.status = status
            selectedItem.assigne = assignee
            selectedItem.date = date
            
            delegate?.didUpdateItem(selectedItem)
        }
        
        dismiss(animated: true)
        
    }
    
    
}

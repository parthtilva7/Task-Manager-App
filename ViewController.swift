//  ViewController.swift
//  Task Manager
//  Created by Dhruvkumar Sanjaybhai Patel on 23/03/2024.

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty else{
            return}
        guard let password = passwordTF.text, !password.isEmpty else {
            return }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("Signin Error: \(e.localizedDescription)")
                let alertBox = UIAlertController(title: "Authorization Denied", message: "Incorrect Email or Password", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
                return
                
            }
            else {
                self.performSegue(withIdentifier: "goToDo", sender: self)
                
                print("Signed In!")
                self.loadData()
                self.getToken()
                
            }
        }
    }
    
    private func loadData() {
        let endpoint = "https://info-6125-5c725-default-rtdb.firebaseio.com/w24/project.json" //
        guard let url = URL(string: endpoint) else {
            print("URL not valid")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            print("Network call completed Successfully!")
            guard error == nil else {
                print("Error:", error!)
                return
            }
            guard let data = data else {
                print("Data Not Found")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Load Data:", json)
                } else {
                    print("Invalid format")
                }
            } catch {
                print("Error parsing JSON:", error)
            }
        }
        dataTask.resume()
    }
    private func getToken() {
           
           guard let currentUser = Auth.auth().currentUser else {
               print("User Not Found")
               return
           }
           
           currentUser.getIDTokenResult(forcingRefresh: false) { tokenResult, error in
               if let error = error {
                   print("Error", error.localizedDescription)
                   return
               }
               
               if let tokenResult = tokenResult {
                   let token = tokenResult.token
                   print("Token =",token)
                   
                   self.performSegue(withIdentifier: "goToDo", sender: token)
               }
           }
       }
    
}


struct Task: Decodable {
    let id: String
    let name: String
    let status: Int
    let type: Int
}
struct TaskList: Decodable {
    let tasks: [Task]
}

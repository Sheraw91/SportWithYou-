//
//  AddProgramController.swift
//  
//
//  Created by Dany Jean-Charles on 21/05/2019.
//

import UIKit
import Firebase

class AddProgramController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = .gray
        setupTextfieldsManaging()
       
    }
    

    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var reptetitionTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ex01: UITextField!
    @IBOutlet weak var ex02: UITextField!
    @IBOutlet weak var ex03: UITextField!
    @IBOutlet weak var ex04: UITextField!
    @IBOutlet weak var ex05: UITextField!
    @IBOutlet weak var ex06: UITextField!
    @IBOutlet weak var ex07: UITextField!
    @IBOutlet weak var ex08: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pauseTime: UITextField!
    @IBOutlet weak var exTime: UITextField!
    
    
    
    @IBAction func addProgram(_ sender: UIButton) {
        if timeTF.text != "" && reptetitionTF.text != "" && nameTF.text != "" && ex01.text != "" && pauseTime.text != "" && exTime.text != ""{

                        let ref = Database.database().reference()
                        let userID = Auth.auth().currentUser?.uid
                        
                        if ex02.text == "" {
                            ex02.text = "none"
                        }
                        if ex03.text == "" {
                            ex03.text = "none"
                        }
                        if ex04.text == "" {
                            ex04.text = "none"
                        }
                        if ex05.text == "" {
                            ex05.text = "none"
                        }
                        if ex06.text == "" {
                            ex06.text = "none"
                        }
                        if ex07.text == "" {
                            ex07.text = "none"
                        }
                        if ex08.text == "" {
                            ex08.text = "none"
                        }
                        
                        
                        
            ref.child("users").child(userID!).child("my-program").setValue(["Pause Time ": pauseTime.text! ,"Ex Time ": exTime.text!, "timeTF": self.timeTF.text!, "repetition": self.reptetitionTF.text!, "nameTF": self.nameTF.text!, "ex01": self.ex01.text!, "ex02": self.ex02.text!,"ex03": self.ex03.text!,"ex04": self.ex04.text!,"ex05": self.ex05.text!,"ex06": self.ex06.text!,"ex07": self.ex07.text!,"ex08": self.ex08.text!])
                        
                        print("Ajout d'un programme réussi ✅")
                        
                        // Redirection vers l'accueil
                        statusLabel.text = "Program is added."
                    }
        
            
                // gestion error
            else {
                print("Missings field.")
                let alertController = UIAlertController(title : "Warning", message: "Missing fields", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
    
    }
    
    private func setupTextfieldsManaging() {
        timeTF.delegate = self
        reptetitionTF.delegate = self
        nameTF.delegate = self
        ex01.delegate = self
        ex02.delegate = self
        ex03.delegate = self
        ex04.delegate = self
        ex05.delegate = self
        ex06.delegate = self
        ex07.delegate = self
        ex08.delegate = self
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @objc private func hideKeyboard() {
        timeTF.resignFirstResponder()
        reptetitionTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        ex01.resignFirstResponder()
        ex02.resignFirstResponder()
        ex03.resignFirstResponder()
        ex04.resignFirstResponder()
        ex05.resignFirstResponder()
        ex06.resignFirstResponder()
        ex07.resignFirstResponder()
        ex08.resignFirstResponder()
        
    }
    
}


// MARK: - Text Field Manager
extension AddProgramController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

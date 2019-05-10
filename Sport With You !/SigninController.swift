//
//  SigninController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 07/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SigninController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextfieldsManaging()
        
        //date configuration
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(SigninController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        birthdayTextfield.inputView = datePicker
        
        
    }
    
    
    // Text Field
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var birthdayTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    
    // Button
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    private func setupButtons() {
        registerButton.layer.cornerRadius = 20
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupTextfieldsManaging() {
        firstnameTextfield.delegate = self
        lastnameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
        usernameTextfield.delegate = self
        birthdayTextfield.delegate = self
        countryTextfield.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @objc private func hideKeyboard() {
        firstnameTextfield.resignFirstResponder()
        lastnameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
        usernameTextfield.resignFirstResponder()
        birthdayTextfield.resignFirstResponder()
        countryTextfield.resignFirstResponder()
    }
    
    
    
    @IBAction func signupButtonWasPressed(_ sender: UIButton) {
        if firstnameTextfield.text != "" && lastnameTextfield.text != "" && usernameTextfield.text != "" && emailTextfield.text != "" && passwordTextfield.text != "" && confirmPasswordTextfield.text != "" && countryTextfield.text != "" && birthdayTextfield.text != ""{
            
            if passwordTextfield.text == confirmPasswordTextfield.text
            {
                Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
                {
                    (authResult, error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                    else
                    {
                    
                        let ref = Database.database().reference()
                        let userID = Auth.auth().currentUser?.uid
                    
                        ref.child("users").child(userID!).setValue(["firstname": self.firstnameTextfield.text!, "lastname": self.lastnameTextfield.text!, "username": self.usernameTextfield.text!, "email": self.emailTextfield.text!, "country": self.countryTextfield.text!, "birthday": self.birthdayTextfield.text!, "url-img-pp": "https://firebasestorage.googleapis.com/v0/b/sportwithyou-ynov.appspot.com/o/profile_default.png?alt=media&token=8703a325-8607-43f8-8d75-b4c6596e01aa"])
                        
                        print("Inscription de \(self.usernameTextfield.text ?? "no name") réussie ✅")

                            // Redirection vers l'accueil
                            self.performSegue(withIdentifier: "goToHome2", sender: self)
                    }
                }
            }
            // gestion error
            else {
                print("Password are not the same.")
                let alertController = UIAlertController(title : "Warning", message: "Password are not the same.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        // gestion error
        else {
            print("Error : missing fields.")
            let alertController = UIAlertController(title : "Warning", message: "Missing fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // date configuration
    @objc private func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        birthdayTextfield.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

// MARK: - Text Field Manager
extension SigninController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

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
    
    //View for colo button
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewCenter2: UIView!
    
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
        // Create a gradient layer for register
        let gradient = CAGradientLayer()
        // gradient colors in order which they will visually appear
        gradient.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
        // Gradient from left to right
        gradient.startPoint = CGPoint(x: 0.0, y: 0.7)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.7)
        // set the gradient layer to the same size as the view
        gradient.frame = viewCenter.bounds
        // add the gradient layer to the views layer for rendering
        viewCenter.layer.insertSublayer(gradient, at: 0)
        // Tha magic! Set the button as the views mask
        viewCenter.mask = registerButton
        //Set corner Radius and border Width of button
        registerButton.layer.cornerRadius =  viewCenter.frame.size.height / 2
        registerButton.layer.borderWidth = 5.0
        
        // Create a gradient layer for login button
        let gradient2 = CAGradientLayer()
        // gradient colors in order which they will visually appear
        gradient2.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        // Gradient from left to right
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradient2.endPoint = CGPoint(x: 1.0, y: 0.3)
        // set the gradient layer to the same size as the view
        gradient2.frame = viewCenter2.bounds
        // add the gradient layer to the views layer for rendering
        viewCenter2.layer.insertSublayer(gradient2, at: 0)
        // Tha magic! Set the button as the views mask
        viewCenter2.mask = loginButton
        //Set corner Radius and border Width of button
        loginButton.layer.cornerRadius =  viewCenter2.frame.size.height / 2
        loginButton.layer.borderWidth = 5.0
        
        
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
    
    
    @IBAction func goSB(_ sender: UIButton) {
        self.performSegue(withIdentifier: "go3sb", sender: self)

    }
    
    @IBAction func signupAction(_ sender: UIButton) {
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
                        
                        let raz = 0
                        
                        
                        ref.child("users").child(userID!).setValue(["firstname": self.firstnameTextfield.text!, "lastname": self.lastnameTextfield.text!, "username": self.usernameTextfield.text!, "email": self.emailTextfield.text!, "country": self.countryTextfield.text!, "birthday": self.birthdayTextfield.text!, "url-img-pp": "https://firebasestorage.googleapis.com/v0/b/sportwithyou-ynov.appspot.com/o/profile_default.png?alt=media&token=8703a325-8607-43f8-8d75-b4c6596e01aa", "weight": 0, "height": 0, "gender": "none", "level": "beginner", "weight-progress": raz])
                        
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

//
//  ViewController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 07/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    // Buttons
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextfieldsManaging()
    }

    private func setupButtons() {
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupTextfieldsManaging() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @objc private func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
 
    @IBAction func loginButtonWasPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error != nil {
                //gestion error
                print(error.debugDescription)
                let alertController = UIAlertController(title : "Warning", message: "Email or Password incorrect", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Try again", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                print(" ✅✅ LOGIN SUCCESS ✅✅")
                self.performSegue(withIdentifier: "goToHome3", sender: self)
            }
        }
    }
    
    
    
    
}

    
// MARK: - Text Field Manager
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

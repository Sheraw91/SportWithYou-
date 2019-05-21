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
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewCenter2: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextfieldsManaging()
        

    }

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
    
 
    @IBAction func loginAction(_ sender: UIButton) {
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
  

    @IBAction func registerAction(_ sender: UIButton) {
        print("ok")
        self.performSegue(withIdentifier: "goRegister", sender: self)
        print("mdr")
    }
    
    
    
}

    
// MARK: - Text Field Manager
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//
//  ProfileController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // bar color status
        UIApplication.shared.statusBarView?.backgroundColor = .gray

        tabBarItem = UITabBarItem(title: "My profile", image: UIImage(named: "user"), tag: 4)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewCenter2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupButtons()
        
        
        
        
        if let user = Auth.auth().currentUser {
            
            let ref = Database.database().reference()
            let uiserID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(uiserID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let username = value?["username"] as? String ?? "no username :("
                let height = value?["height"] as? String ?? "no height :("
                let weight = value?["weight"] as? String ?? "no weight :("
                let level = value?["level"] as? String ?? "no level :("
        
                self.usernameLabel.text = username
                self.heightLabel.text! = height
                self.weightLabel.text! = weight
                self.levelLabel.text! = level

                
  
                
               ref.child("users").child(uiserID!).child("url-img-pp").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let item = snapshot.value as? String{
        
                        let storage = Storage.storage()
                        var reference: StorageReference!
                        reference = Storage.storage().reference(forURL: item)
                        reference.downloadURL { (url, error) in
                            let data = NSData(contentsOf: url!)
                            let image = UIImage(data: data! as Data)
                            self.profilePictureImageView.image = image
                            
                        }
                    }
                
                })
                
            }
            
            
        } else {
            fatalError("⛔️ Erreur : aucun utilisateur est connecté lors de l'affichage de l'écran d'accueil")
        }
        
    }
    
    


    @IBAction func returnToSignupScreen(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Impossible de deconnecter l'utilisateur")
        }
    }
    
    // Action to go edit profile
    @IBAction func goEditProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editingProfile", sender: self)
    }
    private func setupButtons() {
        // Create a gradient layer for register
        let gradient = CAGradientLayer()
        // gradient colors in order which they will visually appear
        gradient.colors = [UIColor.orange.cgColor, UIColor.orange.cgColor]
        // Gradient from left to right
        gradient.startPoint = CGPoint(x: 0.0, y: 0.7)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.7)
        // set the gradient layer to the same size as the view
        gradient.frame = viewCenter.bounds
        // add the gradient layer to the views layer for rendering
        viewCenter.layer.insertSublayer(gradient, at: 0)
        // Tha magic! Set the button as the views mask
        viewCenter.mask = successButton
        //Set corner Radius and border Width of button
        successButton.layer.cornerRadius =  viewCenter.frame.size.height / 2
        successButton.layer.borderWidth = 5.0
        
        // Create a gradient layer for login button
        let gradient2 = CAGradientLayer()
        // gradient colors in order which they will visually appear
        gradient2.colors = [UIColor.orange.cgColor, UIColor.orange.cgColor]
        // Gradient from left to right
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradient2.endPoint = CGPoint(x: 1.0, y: 0.3)
        // set the gradient layer to the same size as the view
        gradient2.frame = viewCenter2.bounds
        // add the gradient layer to the views layer for rendering
        viewCenter2.layer.insertSublayer(gradient2, at: 0)
        // Tha magic! Set the button as the views mask
        viewCenter2.mask = progressButton
        //Set corner Radius and border Width of button
        progressButton.layer.cornerRadius =  viewCenter2.frame.size.height / 2
        progressButton.layer.borderWidth = 5.0
        
        
        
    }
    
}

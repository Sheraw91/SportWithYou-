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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // button config
        successButton.layer.cornerRadius = 13
        successButton.layer.borderWidth = 2
        successButton.layer.borderColor = UIColor.black.cgColor
        successButton.layer.shadowColor = UIColor.gray.cgColor
        successButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        successButton.layer.shadowOpacity = 1
        successButton.layer.shadowRadius = 3.0
        successButton.clipsToBounds = false
        
        progressButton.layer.cornerRadius = 13
        progressButton.layer.borderWidth = 2
        progressButton.layer.borderColor = UIColor.black.cgColor
        progressButton.layer.shadowColor = UIColor.gray.cgColor
        progressButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        progressButton.layer.shadowOpacity = 1
        progressButton.layer.shadowRadius = 3.0
        progressButton.clipsToBounds = false
        
        
        
        
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
 
    
}

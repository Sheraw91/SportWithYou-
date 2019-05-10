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
        tabBarItem = UITabBarItem(title: "My profile", image: UIImage(named: "user"), tag: 4)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            
            let ref = Database.database().reference()
            let uiserID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(uiserID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let username = value?["username"] as? String ?? "no username :("
                let firstname = value?["firstname"] as? String ?? "no firstname :("
                let lastname = value?["lastname"] as? String ?? "no lastname :("
                let birthday = value?["birthday"] as? String ?? "no birthday :("
                let country = value?["country"] as? String ?? "no country :("
                
        
                self.usernameLabel.text = username
                self.firstnameLabel.text = firstname
                self.lastnameLabel.text = lastname
                self.birthdayLabel.text = birthday
                self.countryLabel.text = country
                
  
                
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

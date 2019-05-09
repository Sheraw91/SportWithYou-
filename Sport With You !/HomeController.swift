//
//  HomeController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 2)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = Auth.auth().currentUser {
            
            let ref = Database.database().reference()
            let uiserID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(uiserID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let username = value?["username"] as? String ?? "no username"
                
                self.nameLabel.text = username
                
            }
            
            
        } else {
            fatalError("⛔️ Erreur : aucun utilisateur est connecté lors de l'affichage de l'écran d'accueil")
        }
 
    }
 



}

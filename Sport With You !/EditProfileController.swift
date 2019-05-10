//
//  EditProfileController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func cancelEditingProfile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "cancelEditingProfile", sender: self)
    }
    
}

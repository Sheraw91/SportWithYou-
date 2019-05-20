//
//  ActivityController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 16/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class ActivityController: UIViewController {
    
    
    
    @IBOutlet weak var loading: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.loadGif(name: "loading")
       
    }
}

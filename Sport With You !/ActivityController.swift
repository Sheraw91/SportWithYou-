//
//  ActivityController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 16/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class ActivityController: UIViewController {
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.isHidden = false
        if loading.isHidden == false {
            loading.startAnimating()
        }
    }
}

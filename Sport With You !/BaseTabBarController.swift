//
//  BaseTabBarController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class BaseTabBarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class BaseTabBarController: UITabBarController {
        
        @IBInspectable var defaultIndex: Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            selectedIndex = defaultIndex
        }
        
    }

}

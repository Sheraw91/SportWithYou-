//
//  PopupController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 20/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class PopupController: UIViewController {


    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
        popupView.clipsToBounds = true // cache tout ce qui depasse de la vue
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.black.cgColor

    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    


}

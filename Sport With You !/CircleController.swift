//
//  CircleController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 20/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class CircleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.insuportableView.layer.cornerRadius = 100


    }
    

    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var insuportableView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 3.0) {
            self.insuportableView.loadGif(name: "ex3")
            self.progressView.maxValue = 20
            self.progressView.value = 10
        }
        
    }
}

//
//  Sb1ViewController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 22/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit

class Sb1ViewController: UIViewController {
    // gif config
    public var time: Int=0
    public var timer = Timer()
    @IBOutlet weak var welcomeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        gifLoadView.loadGif(name: "loading3")
        welcomeLabel.isHidden = true
    }
    

    @IBOutlet weak var gifLoadView: UIImageView!
    
    func startLoading(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidEnded), userInfo: nil, repeats: true)
    }
    
     @objc private func timerDidEnded(){
        if time == 4{
            gifLoadView.isHidden = true
            welcomeLabel.isHidden = false
            timer.invalidate()
        }
        time += 1
    }

}

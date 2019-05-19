//
//  ProgramController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import Firebase


class ProgramController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Programs", image: UIImage(named: "calendar"), tag: 3)
    }
    
    
    @IBOutlet weak var beginnerImage: UIImageView!
    @IBOutlet weak var myProgramImage: UIImageView!
    @IBOutlet weak var scaledImage: UIImageView!
    @IBOutlet weak var advancedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = .gray

        myProgramImage.layer.cornerRadius = 13
        myProgramImage.layer.borderWidth = 2
        myProgramImage.layer.borderColor = UIColor.black.cgColor
        myProgramImage.layer.shadowColor = UIColor.gray.cgColor
        myProgramImage.layer.shadowOffset = CGSize(width: 1, height: 2)
        myProgramImage.layer.shadowOpacity = 1
        myProgramImage.layer.shadowRadius = 3.0
        myProgramImage.clipsToBounds = false
        
        beginnerImage.layer.cornerRadius = 13
        beginnerImage.layer.borderWidth = 2
        beginnerImage.layer.borderColor = UIColor.black.cgColor
        beginnerImage.layer.shadowColor = UIColor.gray.cgColor
        beginnerImage.layer.shadowOffset = CGSize(width: 1, height: 2)
        beginnerImage.layer.shadowOpacity = 1
        beginnerImage.layer.shadowRadius = 3.0
        beginnerImage.clipsToBounds = false
        
        scaledImage.layer.cornerRadius = 13
        scaledImage.layer.borderWidth = 2
        scaledImage.layer.borderColor = UIColor.black.cgColor
        scaledImage.layer.shadowColor = UIColor.gray.cgColor
        scaledImage.layer.shadowOffset = CGSize(width: 1, height: 2)
        scaledImage.layer.shadowOpacity = 1
        scaledImage.layer.shadowRadius = 3.0
        scaledImage.clipsToBounds = false
        
        advancedImage.layer.cornerRadius = 13
        advancedImage.layer.borderWidth = 2
        advancedImage.layer.borderColor = UIColor.black.cgColor
        advancedImage.layer.shadowColor = UIColor.gray.cgColor
        advancedImage.layer.shadowOffset = CGSize(width: 1, height: 2)
        advancedImage.layer.shadowOpacity = 1
        advancedImage.layer.shadowRadius = 3.0
        advancedImage.clipsToBounds = false

    }
    
    /*
    @IBOutlet weak var bgView: UIView!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        bgView.layer.addSublayer(gradient)
        
        animateGradient()
        
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    */
}


extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


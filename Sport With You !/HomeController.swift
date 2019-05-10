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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   // TIMER
    
    var time: Int=0
    var timer = Timer()
    var timerIsOn = false
    // gestion du temps
    var addHours = 0
    var addMin = 0
    // temps
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    //ajouter et enlever temps

    
   // Timer configuration
    @IBAction func resetTimer(_ sender: UIButton) {
        sender.shake()
        timer.invalidate()
        time = 0
        updateUI()
        timerIsOn = false
        hoursLabel.text = String("00")
        minutesLabel.text = String("00")
        secondsLabel.text = String("00")
        addHours = 0
        addMin = 0
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        sender.pulsate()
        if timerIsOn == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidEnded), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        sender.pulsate()
        timer.invalidate()
        timerIsOn = false
    }
    
    @objc private func timerDidEnded(){
        time += 1
        updateUI()
    }
    
    private func updateUI(){
        var hours: Int
        var min: Int
        var sec: Int
        
        hours = time/(60*60)
        min = (time/60)%60
        sec = (time % 60)
        
        // Règle le pb d'affichage 0:0:0s
        if hours < 10{
            hoursLabel.text = String("0\(hours)")
        } else {
            hoursLabel.text = String(hours)
        }
        if min < 10{
            minutesLabel.text = String("0\(min)")
        } else {
            minutesLabel.text = String(min)
        }
        if sec < 10{
            secondsLabel.text = String("0\(sec)")
        } else {
            secondsLabel.text = String(sec)
        }
        
    }
    
    // Gestion du temps + Affichage
    @IBAction func lessTime(_ sender: UIButton) {
        addMin -= 5
        if addMin == 5{
            minutesLabel.text = String("0\(addMin)")
        }
        if addMin <= -1{
            addMin = 55
            addHours -= 1
            if addHours < 10 {
                hoursLabel.text = String("0\(addHours)")
                minutesLabel.text = String(addMin)
            } else {
                hoursLabel.text = String(addHours)
                minutesLabel.text = String(addMin)
            }
        } else {
            minutesLabel.text = String(addMin)
        }
    }
    
    @IBAction func addTime(_ sender: UIButton) {
        addMin += 5
        if addMin == 5{
            minutesLabel.text = String("0\(addMin)")
        }
        if addMin >= 60{
            addMin = 0
            addHours += 1
            if addHours < 10 {
                hoursLabel.text = String("0\(addHours)")
                minutesLabel.text = String("0\(addMin)")
            } else {
            hoursLabel.text = String(addHours)
            minutesLabel.text = String(addMin)
            }
        } else {
            minutesLabel.text = String(addMin)
        }
    }
}

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
        
    }
    
    
    
}

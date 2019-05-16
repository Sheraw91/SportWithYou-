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
import AVFoundation
import UserNotifications
import Foundation

class HomeController: UIViewController {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 2)
    }
    

    
    @IBOutlet weak var gifImae: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gifImae.loadGif(name: "exercises_c (10)")
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let level = value?["level"] as? String ?? "no level :("
            
            self.levelLabel.text = level
        }
        
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        // sleep mode disable
        UIApplication.shared.isIdleTimerDisabled = true

    }
    
    
    
    // When user leave the home
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    // notifications center
  
    @IBOutlet weak var levelLabel: UILabel!
    

    // music var
    var player:AVAudioPlayer = AVAudioPlayer()

    
   // TIMER
    
    public var time: Int=0
    var timer = Timer()
    var timerIsOn = false
    // gestion du temps
    var addHours = 0
    public var addMin = 0
    public var getMin = 0
    // temps
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    //ajouter et enlever temps

    
   // Timer configuration
    @IBAction func resetTimer(_ sender: UIButton) {
        timer.invalidate()
        time = 0
        updateUI()
        timerIsOn = false
        minutesLabel.text = String("00")
        secondsLabel.text = String("00")
        addHours = 0
        addMin = 0
    }
    
    /* START TIMER */
    public var notifs = true

    @IBAction func startTimer(_ sender: UIButton) {
        // Error if time is nil
        time = addMin * 60
        if time == 0 {
            timer.invalidate()
            print("Error : time need to be more than 0.")
            let alertController = UIAlertController(title : "Error", message: "time need to be more than 0. Reset the timer.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true, completion: nil)
            addMin = 0
            time = 0
            timer.invalidate()
            updateUI()
        } else {
        }
        // conditions notifs alert
        if notifs == true {
            conditionAlert(title: "Please read the terms of use before starting the training.", message:"https://www.sportwithyou-ynov.firebaseapp.com/conditions \n You can disable notifications on your profile.")
        } else {
        }
        // timer start config
        getMin = addMin
        if timerIsOn == false {
            if time == 0 {
                timer.invalidate()
                print("Error : time need to be more than 0.")
                let alertController = UIAlertController(title : "Error", message: "time need to be more than 0. Reset the timer.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertController, animated: true, completion: nil)
                addMin = 0
                time = 0
                timer.invalidate()
                updateUI()
            } else {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidEnded), userInfo: nil, repeats: true)
                timerIsOn = true
            }
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        timer.invalidate()
        timerIsOn = false
    }
    
    var prog : [String] = []
    public var z = true
    public var i = 0
    public var display = 0
    
    @objc private func timerDidEnded(){
        updateUI()
        /* BIDOUILLAGE ACTIVÉ */
       
        if (self.levelLabel.text!) == "Beginner" {
            if getMin == 5 { // ( 5min = 300s )
                if time >= 280{
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                    } else {
                    }
                } else if time >= 270 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 250 {
                    if display == 0{
                        gifImae.loadGif(name: "ex2")
                        display += 1
                    } else {
                    }
                } else if time >= 240 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 220 {
                    if display == 0{
                        gifImae.loadGif(name: "ex3")
                        display += 1
                    } else {
                    }
                } else if time >= 210 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 190 {
                    if display == 0{
                        gifImae.loadGif(name: "ex4")
                        display += 1
                    } else {
                    }
                } else if time >= 180 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 160 {
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                    } else {
                    }
                } else if time >= 150 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 130 {
                    if display == 0{
                        gifImae.loadGif(name: "ex2")
                        display += 1
                    } else {
                    }
                } else if time >= 120 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 100 {
                    if display == 0{
                        gifImae.loadGif(name: "ex3")
                        display += 1
                    } else {
                    }
                } else if time >= 90 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 70 {
                    if display == 0{
                        gifImae.loadGif(name: "ex4")
                        display += 1
                    } else {
                    }
                } else if time >= 60 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 40 {
                    if display == 0{
                        gifImae.loadGif(name: "ex5")
                        display += 1
                    } else {
                    }
                } else if time >= 30 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 10 {
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                    } else {
                    }
                }
            }
            if getMin == 10 { // ( 10min = 600s )
                if time >= 580{
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 570 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                    
                } else if time >= 550{
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 540 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 520 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 510 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 490 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 480 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 460 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 450 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 430 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 420{
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 400 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 390 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 370 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 360 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 340 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 330 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 310 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 300 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 10 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                }
                if time >= 280{
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 270 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 250 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 240 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 220 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 210 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 190 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 180 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 160 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 150 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 130 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 120 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 100 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 90 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 70 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 60 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 40 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                } else if time >= 30 {
                    gifImae.loadGif(name: "pause")
                    display = 0
                } else if time >= 10 {
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                }
            }
        }
        
        time -= 1
        // Add song
        if time == 11 {
            do
            {
                let audioPath = Bundle.main.path(forResource: "timer", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            }
            catch
            {
                //PROCESS ERROR
            }
            
            let session = AVAudioSession.sharedInstance()
            
            do
            {
                try session.setCategory(AVAudioSession.Category.playback)
            }
            catch
            {
                
            }
            
            player.play()
        }

 
        if time == 0 {
            timer.invalidate()
            print("Good job ! : time's up.")
            let alertController = UIAlertController(title : "Good job !", message: "time's up.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    private func updateUI(){
        var min: Int
        var sec: Int
        var milisec: Int
        
        min = time/(60*60)
        sec = (time/60)%60
        milisec = (time % 60)
        
        // Règle le pb d'affichage 0:0:0s
        if min < 10{
            minutesLabel.text = String("0\(min)")
        } else {
            minutesLabel.text = String(min)
        }
        if sec < 10{
            minutesLabel.text = String("0\(sec)")
        } else {
            minutesLabel.text = String(sec)
        }
        if milisec < 10{
            secondsLabel.text = String("0\(milisec)")
        } else {
            secondsLabel.text = String(milisec)
        }
        
    }
    
    // Gestion du temps + Affichage
    @IBAction func lessTime(_ sender: UIButton) {
        addMin -= 5
        if addMin == 5{
            minutesLabel.text = String("0\(addMin)")
        }
        else if addMin == 0{
            minutesLabel.text = String("0\(addMin)")
        }
        else if addMin < 0{
            addMin = 55
            minutesLabel.text = String(addMin)
        }
        else {
            minutesLabel.text = String(addMin)
        }
    }
    
    @IBAction func addTime(_ sender: UIButton) {
        addMin += 5
        if addMin < 10{
            minutesLabel.text = String("0\(addMin)")
        }
        else if addMin >= 60{
            addMin = 0
            minutesLabel.text = String("0\(addMin)")
        }
        else {
            minutesLabel.text = String(addMin)
        }
    }
    
    /*
    private func getEx() {
        var z = true
        if (self.levelLabel.text!) == "Beginner" && z == true{
            let userID = Auth.auth().currentUser?.uid
            var recapProg: [Any] = []
            let ref = Database.database().reference().child("programs").child("abs-beginner-10")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        for var j in 0..<(objects.count){
                            recapProg.append(objects[j].value!)
                            j = j + 1
                        }
                        self.prog = recapProg as! [String]
                        let nbrep = Int(self.prog[0])
                        let te = Int(self.prog[1])
                        let tr = Int(self.prog[2])
                        print(self.prog)
                        print("\(nbrep) \(te) \(tr)")
                        self.gifImae.loadGif(name: "pause")
                        self.time = te!
                        self.updateUI()
                        z = false
                    })
                }
            })
            
        } else {
            print("shit")
        }
    }
 */
    
    func conditionAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.notifs = true
        }))
        alert.addAction(UIAlertAction(title: "Don't ask again", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.notifs = false
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
}
/*
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
*/

/* NOTIFICATIONS */
// add notification
//if enableNotification == true{
//    let content = UNMutableNotificationContent()
//    content.title = "Il est temps de se mettre au sport !"
//    content.subtitle = "Êtes-vous prêt ?"
//    content.body = "Venez battre votre record personnel !"
//    content.badge = 1
//
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 82800, repeats: true)
//    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
//
//    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//}


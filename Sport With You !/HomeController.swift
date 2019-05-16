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
    
    @IBOutlet weak var notificationStatusLabel: UILabel!
    var enableNotification = true

    @IBAction func disableNotification(_ sender: UIButton) {
        var status = "Enable"
        if enableNotification == true{
            enableNotification = false
            status = "Disable"
        }else if enableNotification == false{
            enableNotification = true
            status = "Enable"
        }
        notificationStatusLabel.text! = status
    }
    
    // music var
    var player:AVAudioPlayer = AVAudioPlayer()

    
   // TIMER
    
    public var time: Int=0
    var timer = Timer()
    var timerIsOn = false
    // gestion du temps
    var addHours = 0
    public var addMin = 0
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


    @IBAction func startTimer(_ sender: UIButton) {
        // timer start config
        time = addMin * 60
    
        if timerIsOn == false {
            if time == 0 {
                timer.invalidate()
                print("Error : time need to be more than 0.")
                let alertController = UIAlertController(title : "Error", message: "time need to be more than 0", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertController, animated: true, completion: nil)
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
    
    
    @objc private func timerDidEnded(){
        updateUI()
        
        
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


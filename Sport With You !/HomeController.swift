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
import MBCircularProgressBar

class HomeController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //var text picker
    var exercice = ["Legs","Abs","Arms","My program"]
    var picker = UIPickerView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 2)
    }
    
    @IBOutlet weak var gifImae: UIImageView!
    @IBOutlet weak var circleTimeView: MBCircularProgressBarView!

    @IBOutlet weak var actu1: UILabel!
    @IBOutlet weak var actu2: UILabel!
    
    @IBOutlet weak var typeExerciceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // circle
        circleTimeView.layer.cornerRadius = 120
        circleTimeView.value = 0
        circleTimeView.isHidden = true
        circleTimeView.value = 0

        
        exLabel.isHidden = true
        
        // bar color status
        UIApplication.shared.statusBarView?.backgroundColor = .gray

        // clean badges
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // hide button
        resetButton.isHidden = true
        pauseButton.isHidden = true
        startButton.isHidden = false
        actu1.isHidden = false
        actu2.isHidden = false

        
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

        //type exercice
        typeExerciceLabel.isHidden = true
        
        //text picker
        picker.delegate = self
        picker.dataSource = self
        
        typeExerciceTextField.inputView = picker
        
        //setup text field
        typeExerciceTextField.layer.borderWidth = 1
        typeExerciceTextField.layer.borderColor = UIColor.orange.cgColor
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
    var pause = false
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
    //action buttons
    @IBOutlet weak var plusbutton: UIButton!
    @IBOutlet weak var lessButton: UIButton!
    //type exercice
    @IBOutlet weak var typeExerciceTextField: UITextField!
    @IBOutlet weak var exLabel: UILabel!
    
    

    

    
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
        // hide button
        resetButton.isHidden = true
        pauseButton.isHidden = true
        startButton.isHidden = false
        // display button +/-
        plusbutton.isHidden = false
        lessButton.isHidden = false
        //hide gif when ex stop
        gifImae.isHidden = true
        // hide circle
        circleTimeView.isHidden = true
        // Type ex and label text ex
        typeExerciceLabel.isHidden = true
        typeExerciceTextField.isHidden = false
        actu1.isHidden = false
        actu2.isHidden = false
        exLabel.isHidden = true
    }
    
    /* START TIMER */
    public var notifs = true

    @IBAction func startTimer(_ sender: UIButton) {
        exLabel.isHidden = false
        actu1.isHidden = true
        actu2.isHidden = true
        resetcirclePause = true
        resetcircleEx = true
        circleTimeView.value = 0
        
        let content = UNMutableNotificationContent()
        content.title = "Vous êtes encore la ?"
        content.subtitle = "Il est temps de se remettre au sport !"
        content.body = "Venez battre votre reccord personnel :)"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
                // display button
                resetButton.isHidden = false
                pauseButton.isHidden = false
                // hide button +/-
                plusbutton.isHidden = true
                lessButton.isHidden = true
                startButton.isHidden = true

                // type ex
                typeExerciceLabel.isHidden = false
                typeExerciceTextField.isHidden = true
                typeExerciceLabel.text = typeExerciceTextField.text
                
                //hide gif when ex stop
                gifImae.isHidden = false
                // start timer
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidEnded), userInfo: nil, repeats: true)
                timerIsOn = true
            }
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        timer.invalidate()
        timerIsOn = false
        
        if pause == true{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidEnded), userInfo: nil, repeats: true)
            pause = false
        } else {
            timer.invalidate()
            pause = true

        }
    }
    
    var prog : [String] = []
    public var z = true
    public var i = 0
    public var display = 0
    var resetcirclePause = true
    var resetcircleEx = true

    
    @objc private func timerDidEnded(){
        updateUI()
        /* BIDOUILLAGE ACTIVÉ */
        circleTimeView.isHidden = false
       
        if (self.levelLabel.text!) == "Beginner" {
            if getMin == 5 { // ( 5min = 300s )
                if time >= 280{
                    exLabel.text = "Down Up"
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex18")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 270 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                    
                else if time >= 250 {
                    exLabel.text = "Lunges"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 240 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                
                    
                else if time >= 220 {
                    exLabel.text = "Jumping Jack"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex7")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 210 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                
                    
                else if time >= 190 {
                    exLabel.text = "One leg squat"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex3")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 180 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                
                else if time >= 160 {
                    exLabel.text = "Lunges"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 150 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                else if time >= 130 {
                    exLabel.text = "Jumping Jack"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex7")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 120 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                    
                else if time >= 100 {
                    exLabel.text = "Down Up"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex18")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 90 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                else if time >= 70 {
                    exLabel.text = "One Leg Squat"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex3")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 60 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                else if time >= 40 {
                    exLabel.text = "Lunges"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                } else if time >= 30 {
                    exLabel.text = ""
                    circleTimeView.maxValue = 10
                    if resetcirclePause == true {
                        circleTimeView.value = 10
                        resetcirclePause = false
                    }
                    gifImae.loadGif(name: "pause")
                    display = 0
                    UIView.animate(withDuration: 1.0) {
                        self.circleTimeView.value -= 1
                    }
                }
                else if time >= 20 {
                    exLabel.text = "Jumping"
                    resetcirclePause = true
                    if resetcircleEx == true {
                        circleTimeView.value = 0
                        resetcircleEx = false
                    }
                    circleTimeView.maxValue = 20
                    if display == 0{
                        gifImae.loadGif(name: "ex7")
                        display += 1
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    } else {
                        UIView.animate(withDuration: 1.0) {
                            self.circleTimeView.value += 1
                        }
                    }
                }
                
            }

            else if getMin == 10 { // ( 10min = 600s )
                if time >= 580{
                    if display == 0{
                        gifImae.loadGif(name: "ex1")
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
                   // timeOut()
                    if display == 0{
                        gifImae.loadGif(name: "exercises_c (10)")
                        display += 1
                    } else {
                    }
                }
            }
        }
        
        time -= 1
 
        if time == 0 {
            timer.invalidate()
            // hide and show element
            typeExerciceLabel.isHidden = true
            typeExerciceTextField.isHidden = false
            circleTimeView.isHidden = true
            print("Good job ! : time's up.")
            let alertController = UIAlertController(title : "Good job !", message: "time's up.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            // hide button
            resetButton.isHidden = true
            pauseButton.isHidden = true
            startButton.isHidden = false
            // display button +/-
            plusbutton.isHidden = false
            lessButton.isHidden = false
            //hide gif when ax stop
            gifImae.isHidden = true
            actu1.isHidden = false
            actu2.isHidden = false
            exLabel.isHidden = true

        }
    }
        


    /*func timeOut() {
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
    }*/

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
    
        /* NOTIFICATIONS */
    func conditionAlert(title:String, message:String){
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
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercice.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercice[row]
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeExerciceTextField.text = exercice[row]
        self.view.endEditing(false)
    }

}


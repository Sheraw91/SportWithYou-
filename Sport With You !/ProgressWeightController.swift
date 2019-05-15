//
//  ProgressWeightController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 13/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Charts

class ProgressWeightController: UIViewController {

    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHome3", sender: self)

    }
    
    var numbers : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfieldsManaging()
    }
    
    
    @IBAction func loadProgress(_ sender: UIButton) {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!).child("weight-progress")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    for var j in 0..<(objects.count){
                        //print(objects[j].value!)
                        let progressWeight = [objects[j].value!]
                        print(progressWeight)
                        j = j + 1
                    }
                })
            }
        })
    }
    
    
    @IBAction func addWeight(_ sender: UIButton) {
        
        
        let input = Double(currentWeightTextField.text!) // get input of textfield
        numbers.append(input!) // Add data to array
        updateGraph()
        
        // Add to database
        let refe = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        refe.child("users").child(userID!).updateChildValues(["weight-progress": numbers])
        
        /*  Try to catch values */
        var recapWeight: [Any] = []
        let ref = Database.database().reference().child("users").child(userID!).child("weight-progress")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    for var j in 0..<(objects.count){
                        //print(objects[j].value!)
                       // let progressWeight = [objects[j].value!]
                        recapWeight.append(objects[j].value!)
                        j = j + 1
                    }
                    print(recapWeight)
                })
            }
        })
        
        
    }
    
    func updateGraph(_ count: Int = 20){
        var lineChartEntry = [ChartDataEntry]()
        
       
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Weight") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        
        let data = LineChartData() //This is the object that will be added to the chart
        
        data.addDataSet(line1) //Adds the line to the dataSet
        
        self.lineChartView.data = data // draw
    }
    
    
    private func setupTextfieldsManaging() {
        currentWeightTextField.delegate = self 
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @objc private func hideKeyboard() {
        currentWeightTextField.resignFirstResponder()
    }
    
}

// MARK: - Text Field Manager
extension ProgressWeightController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

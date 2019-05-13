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

    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    
     var numbers : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfieldsManaging()

    }
    
    @IBAction func addWeight(_ sender: UIButton) {
        
        
        let input = Double(currentWeightTextField.text!) // get input of textfield
        numbers.append(input!) // Add data to array
        updateGraph()
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
        
        self.lineChartView.data = data
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

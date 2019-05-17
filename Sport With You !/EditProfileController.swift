//
//  EditProfileController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController, UIPickerViewDataSource,  UIPickerViewDelegate  {
    
    //Picker View
    let level = ["Beginner","Scaled","Advanced"]
    let gender = ["Male", "Female", "Other"]
    let piker1 = UIPickerView()
    let piker2 = UIPickerView()

    
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var default_userView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // bar color status
        UIApplication.shared.statusBarView?.backgroundColor = .gray

        setupTextfieldsManaging()
        
        //Picker View
        
        piker1.delegate = self
        piker1.dataSource = self
        
        piker2.delegate = self
        piker2.dataSource = self
        
        levelTextField.inputView = piker1
        genderTextField.inputView = piker1
        
        levelTextField.inputView = piker2
        genderTextField.inputView = piker2
        
        piker1.tag = 1
        piker2.tag = 2
        
        levelTextField.inputView = piker1
        genderTextField.inputView = piker2
        
        //Profil picture
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        default_userView.isUserInteractionEnabled = true
        default_userView.addGestureRecognizer(imageTap)
        default_userView.layer.cornerRadius = default_userView.bounds.height / 2
        default_userView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        // affichage de la pp acutelle
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).child("url-img-pp").observeSingleEvent(of: .value, with: { (snapshot) in
            if let item = snapshot.value as? String{
                
                let storage = Storage.storage()
                var reference: StorageReference!
                reference = Storage.storage().reference(forURL: item)
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.default_userView.image = image
                }
            }
            
        })
    }
    
    
    
    @objc func openImagePicker(_ sender:Any){
        // ouvre la galerie
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func cancelEditingProfile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "cancelEditingProfile", sender: self)
    }
    
    
    /* save au profil
     1. Upload image to Firebase Storage
     2. Save profile to Fifrebase Database
     3. Dismiss the view
    */
    
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var newMailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    
    
    @IBAction func saveInfoButton(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        guard let image = default_userView.image else { return }

        self.uploadProfileImage(image) { url in
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(userID!).updateChildValues(["url-img-pp": url ])
            
        }
        
        if newUsernameTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["username": newUsernameTextField.text!])
        } else {
            print("Aucun changement de : Username")
        }
        if newMailTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["email": newMailTextField.text!])
        } else {
            print("Aucun changement de : email")
        }
        if heightTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["height": heightTextField.text!])
        } else {
            print("Aucun changement de : height")
        }
        if weightTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["weight": weightTextField.text!])
        } else {
            print("Aucun changement de : weight")
        }
        if genderTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["gender": genderTextField.text!])
        } else {
            print("Aucun changement de : gender")
        }
        if levelTextField.text != "" {
            ref.child("users").child(userID!).updateChildValues(["level": levelTextField.text!])
        } else {
            print("Aucun changement de : level")
        }
        
        self.performSegue(withIdentifier: "saveEditingProfile", sender: self)
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:String?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                //success
                if let url = metaData?.downloadURL()?.absoluteString{
                    completion(url)
                } else {
                    // failed
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    // text reco
    private func setupTextfieldsManaging() {
        newUsernameTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        newMailTextField.delegate = self
        genderTextField.delegate = self
        levelTextField.delegate = self

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    @objc private func hideKeyboard() {
        newUsernameTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        newMailTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        levelTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        if pickerView == piker1 {
            return level.count
            
        } else if pickerView == piker2{
            return gender.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == piker1 {
            return level[row]
            
        } else if pickerView == piker2{
            return gender[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == piker1 {
            levelTextField.text = level[row]
            self.view.endEditing(false)
        } else if pickerView == piker2{
            genderTextField.text = gender[row]
            self.view.endEditing(false)
        }
    }
    
    
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.default_userView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

}

extension EditProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

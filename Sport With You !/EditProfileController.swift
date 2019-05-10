//
//  EditProfileController.swift
//  Sport With You !
//
//  Created by Dany Jean-Charles on 09/05/2019.
//  Copyright © 2019 Dany Jean-Charles. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController  {

    var imagePicker:UIImagePickerController!
    @IBOutlet weak var default_userView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    @IBAction func saveInfoButton(_ sender: UIButton) {
        
        guard let image = default_userView.image else { return }

        self.uploadProfileImage(image) { url in
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(userID!).updateChildValues(["url-img-pp": url ])
            
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

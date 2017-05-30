//
//  LoginController+handlers.swift
//  wink
//
//  Created by Hao Wu on 5/29/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleLoginRegister() {
        if loginRegisterSegementedControll.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    
    func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                //print(error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                //print("an error has occurred")
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //authentication successful
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabase(uid: uid, values: values as [String : AnyObject])
                    }
                    
                    
                    
                    //print(metadata!)
                    
                })
            }
            
            
            
            
            
        })
        
        
        
    }
    
    
    private func registerUserIntoDatabase(uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let usersReference = ref.child("users").child(uid)
        
        //let values = ["name": name, "email": email]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("an error has occurred during updateChildValues")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }

    
    
    func handleSelectProfileImageView() {
        
        //print("handle select profile image view")
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        //profileImageView.image = selectedImageFromPicker
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

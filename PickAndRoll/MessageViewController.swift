//
//  MessageViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 16/06/17.
//  Copyright © 2017 CISPL. All rights reserved.

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class MessageViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 200
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        emailLabel.text = FIRAuth.auth()!.currentUser!.email
        profileImage.isUserInteractionEnabled = true
        var TapGesture = UITapGestureRecognizer(target: self, action: "ImageTapped")
        self.profileImage.addGestureRecognizer(TapGesture)
    }
    
    
    
    func ImageTapped() {
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
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        
        
        
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("pickroll_profile_images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
            
            storageRef.put(uploadData, metadata: nil, completion: {(metadata,error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                    
                    let values = ["Email":FIRAuth.auth()!.currentUser!.email,"profileImageUrl":profileImageUrl]
                    self.registerUserIntoDatabaseWithUID(uid: FIRAuth.auth()!.currentUser!.uid, values: values as [String : AnyObject])
                }
                
                
            })
        
    
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    func registerUserIntoDatabaseWithUID(uid:String,values:[String:AnyObject]){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://pickandroll-e0897.firebaseio.com/")
        // let userReference = ref.child("UserDetails").child("User1").child(uid)
        let userReference = ref.child("Users").child(uid)
        
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
           // self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    

    
    
    
}

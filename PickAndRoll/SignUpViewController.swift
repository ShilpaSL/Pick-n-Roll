//
//  SignUpViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 21/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift
import FirebaseAuth
import GoogleMaps
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTextStyling(changeText: nameField)
        setTextStyling(changeText: emailField)
        setTextStyling(changeText: passwordField)
        // Do any additional setup after loading the view.
    }
    
    func setTextStyling(changeText: UITextField) {
        let myColor = UIColor.white
        changeText.layer.borderColor = myColor.cgColor
        changeText.layer.borderWidth = 1.0
        changeText.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
    }
    
    

    @IBAction func SignUp(_ sender: Any) {
        
        if let name = nameField.text,let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                self.performSegue(withIdentifier: "SignIn", sender: nil)
                
            
            }
        }
    }
    
    
    
    
}

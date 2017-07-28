//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    var userID = ""
    var userEmail = ""
    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
            print("registered")
            
            userID = FIRAuth.auth()!.currentUser!.uid
            userEmail = (FIRAuth.auth()!.currentUser?.email)!
            
            
        }
    }
    

    @IBAction func SignIn(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    
                    self.CompleteSignIn(id: user!.uid)
                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                    
                    let userSignIn: String = FIRAuth.auth()!.currentUser!.uid
                    let userEmailIn : String = (FIRAuth.auth()!.currentUser?.email)!
                    
                    
                    
                }
            }
        }
    }
    func CompleteSignIn(id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
    }


}

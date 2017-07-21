//
//  menuViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 16/06/17.
//  Copyright © 2017 CISPL. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    var loggedUserEmail = ""
    var myUserId = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
         myUserId = FIRAuth.auth()!.currentUser!.uid
        loggedUserEmail = FIRAuth.auth()!.currentUser!.email!
        
        print("useridddd---\(myUserId)")
        
        var ref = FIRDatabase.database().reference()
        print("useridddd ref---\(ref)")
        var productRef = ref.child("Users/\(myUserId)/profileImageUrl")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let dbvalue = snapshot.value as? String
            
           print("dbvalue is --\(dbvalue)")
        })
        
        
        
        ManuNameArray = ["Home","MyProfile","Map","Create Album"]
        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!]
        
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.green.cgColor
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
    }

    
    func tapDetected() {
        print("Imageview Clicked")
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
            imgProfile.image = selectedImage
            
            
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("pickroll_profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(imgProfile.image!) {
                
                storageRef.put(uploadData, metadata: nil, completion: {(metadata,error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        
                        print(self.loggedUserEmail)
                        
                        
                        let values = ["Email":self.loggedUserEmail,"profileImageUrl":profileImageUrl]
                       
                        self.changeProfilePicInDatabase(myUserId:self.myUserId,values:values as [String : AnyObject] )
                        
                        
                    }
                    
                    
                })
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
     func changeProfilePicInDatabase(myUserId:String,values:[String:AnyObject]){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://pickandroll-e0897.firebaseio.com/")
        // let userReference = ref.child("UserDetails").child("User1").child(uid)
        let userReference = ref.child("Users").child(myUserId)
        
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        if cell.lblMenuname.text! == "Home"
        {
            print("Home Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        if cell.lblMenuname.text! == "Email"
        {
            print("message Tapped")
           
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "Map"
        {
            print("Map Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MapVC") as! DisplayMapViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "Create Album"
        {
           print("Create Album Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "CreateAlbumViewController") as! CreateAlbumVC
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
    }
    

}

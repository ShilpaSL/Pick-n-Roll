//
//  SignUpViewController.swift
//  PickAndRoll
//
//  Created by Badrinath kangundi on 21/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import KeychainSwift
import GoogleMaps



class SignUpViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    var userID = ""
    var userEmail = ""
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    var current_lattitude = 0.0
    var current_longitude = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: 12.971599, longitude: 77.594563, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        // view = mapView
        
        
        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
            
            userID = FIRAuth.auth()!.currentUser!.uid
            userEmail = (FIRAuth.auth()!.currentUser?.email)!
            
           
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        //  self.view = mapView
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        marker.map = self.mapView
        current_lattitude = userLocation!.coordinate.latitude
        current_longitude = userLocation!.coordinate.longitude
        print("current location in view controller -->\(current_lattitude) & \(current_longitude)")
        
        locationManager.stopUpdatingLocation()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CompleteSignIn(id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
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
                
             
                let imageName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("pickroll_profile_images").child("\(imageName).png")
                var profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/pickandroll-e0897.appspot.com/o/pickroll_profile_images%2F002DE673-58CA-4170-A9D8-D58EBEDE643F.png?alt=media&token=405717b8-4046-4d32-ab4c-13b93165050f"
                let values = ["Name":name,"Email":email,"profileImageUrl":profileImageUrl,"lat":String(self.current_lattitude),"lng":String(self.current_longitude)]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                
                self.performSegue(withIdentifier: "LoginIn", sender: nil)
                
            }
        }
        
    }
    private func registerUserIntoDatabaseWithUID(uid:String,values:[String:AnyObject]){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://pickandroll-e0897.firebaseio.com/")
      
        let userReference = ref.child("Users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
}

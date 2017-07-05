//
//  DisplayAlbumImagesViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 29/06/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth



class DisplayAlbumImagesViewController: UIViewController {

    var picArray = [UIImage]()
    
    
    @IBOutlet weak var imageFB: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let myUserId = FIRAuth.auth()!.currentUser!.uid
        print("myuserd id is-->\(myUserId)")
        
       
//        //Upload
//        let fileData = NSData() // get data...
//        let storageRef = FIRStorage.storage().reference().child("userFiles/\(myUserId)/CB4E8282-364E-454F-A9A2-2CE2B2DD809A.png")
//        storageRef.put(fileData as Data).observe(.success) { (snapshot) in
//            // When the image has successfully uploaded, we get it's download URL
//            let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
//            // Write the download URL to the Realtime Database
//            let dbRef = FIRDatabase.database().reference().child("userFiles/\(myUserId)/myFile")
//            dbRef.setValue(downloadURL)
//        }
                        //Download
        
        let dbRef = FIRDatabase.database().reference().child("Files/UserId")
        dbRef.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            print("downloadURL is--\(downloadURL)")
            // Create a storage reference from the URL
//            let storageRef = FIRStorage.storage().reference(forURL: downloadURL)
//            print("sref is--\(storageRef)")
            
            
//            // Download the data, assuming a max size of 1MB (you can change this as necessary)
//            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//                // Create a UIImage, add it to the array
////                let pic = UIImage(data: data!)
////                self.imageFB.image = pic
////                self.picArray.append(pic!)
//            }
            
            
            if let url = NSURL(string: downloadURL) {
                if let imageData = NSData(contentsOf: url as URL) {
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                     self.imageFB.image = dataImage
                    
                }        
            }
            
            
        })
           
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
       // let imageName = "F5C898B9-72EC-4726-A5EA-DB2C1CE5C3A0.jpg"
//        let imageURL = FIRStorage.storage().reference(forURL: "gs://pickandroll-e0897.appspot.com").child("Birthday")
//        print(imageURL)
//
//        imageURL.downloadURL(completion: { (url, error) in
//            
//            if error != nil {
//                print(error?.localizedDescription)
//                return
//            }
//            
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                
//                if error != nil {
//                    print(error)
//                    return
//                }
//                
//                guard let imageData = UIImage(data: data!) else { return }
//                
//                DispatchQueue.main.async {
//                    self.imageFB.image = imageData
//                }
//                
//            }).resume()
//            
//        })
    
    
        
    

   

}

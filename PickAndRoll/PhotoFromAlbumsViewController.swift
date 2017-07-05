//
//  PhotoFromAlbumsViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 05/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PhotoFromAlbumsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var imagesFromDB = [String]()
    var test = [UIImage]()
    var imageArrayLength = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let myUserId = FIRAuth.auth()!.currentUser!.uid
        print("myuserd id is-->\(myUserId)")
        
        let dbRef = FIRDatabase.database().reference().child("Files/UserId")
        dbRef.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            self.imagesFromDB.append(downloadURL);
            print("downloadURL is--\(downloadURL)")
            // self.imagesFromDB.append(downloadURL)
            //self.imageArrayLength = self.imagesFromDB.count
            print("length is --\(self.imagesFromDB.count)")
            
        })
        
        self.imagesFromDB.append("https://firebasestorage.googleapis.com/v0/b/pickandroll-e0897.appspot.com/o/Files%2FUserId%2F7D50A070-664E-4CD6-A436-C140E5FDEF6D.jpg?alt=media&token=fb3e5fa7-52dd-4d38-ae30-34e97ec435f6")
        
        self.imageArrayLength = self.imagesFromDB.count
        for i in 0...self.imageArrayLength-1 {
            
            if let url = NSURL(string: self.imagesFromDB[i] ) {
                if let imageData = NSData(contentsOf: url as URL) {
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    self.test.append(dataImage!)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesFromDB.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //   cell.imgImage.image = imageName[indexPath.row]
        print(indexPath.row)
        //  imageArrayLength = imagesFromDB.count
        
        cell.imgImage.image = test[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //        var imageName = [UIImage(named: "1"),UIImage(named: "2"),]
    //        var nameArray = ["name 1","name 2",]
    //
    //
    //
    //        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    //        desCV.getImage = imageName[indexPath.row]!
    //        desCV.getName = nameArray[indexPath.row]
    //        self.navigationController?.pushViewController(desCV, animated: true)
    //        
    //    }
    
    
}

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
import JSQMessagesViewController

class PhotoFromAlbumsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var test = [UIImage]()
    var imageArrayLength = 0
    
    var imagesArryFolder = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUserId = FIRAuth.auth()!.currentUser!.uid
        print("myuserd id is-->\(myUserId)")
        
        print("FOLDER ARRAY -->\(imagesArryFolder.count)")
        
        self.imageArrayLength = self.imagesArryFolder.count
        print("imageArrayLength is --\(self.imageArrayLength)")
        if(self.imageArrayLength == 0){
            print("No photos")
        }
        else{
        for i in 0...self.imageArrayLength-1 {
            
            if let url = NSURL(string: self.imagesArryFolder[i] ) {
                if let imageData = NSData(contentsOf: url as URL) {
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    self.test.append(dataImage!)
                    
                                  }
            }
        }
        }
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArryFolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         collectionView.allowsMultipleSelection = true 
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
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        let cell = collectionView.cellForItem(at: indexPath)
         cell?.contentView.backgroundColor = UIColor.green
            
            let img = JSQPhotoMediaItem(image:test[indexPath.row])
       }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
    }
    
}

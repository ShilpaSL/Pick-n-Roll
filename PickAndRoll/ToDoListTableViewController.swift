//
//  ToDoListTableViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 05/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ToDoListTableViewController: UITableViewController {
    
    var items: [Array<String>] = [[String]()]
    var folderName = ""
    var folderIndex = 0
    var imagesFromDB = [String]()
    var imageKeys = [String]()
    var userId = ""
    
    var userFolders = [String]()
    var userKeysFromDB = [String]()
    var sharedUsers = ""
    var sharedUsersArray = [String]()
    
    
    @IBAction func cancelToToDoList(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveToToDoList(_ segue: UIStoryboardSegue) {
        
        let newToDoViewController = segue.source as! NewToDoTableViewController
        
        if let newItem = newToDoViewController.toDoItem {
            items[0].append(newItem)
            tableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userId = FIRAuth.auth()!.currentUser!.uid
        
        print("count of existing array is-->\(self.sharedUsersArray.count)")
        sharedUsers = String(self.sharedUsersArray.count)
        
        let dbRef = FIRDatabase.database().reference().child("Files").child(userId)
        dbRef.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            //  let urlKey = snapshot.key as! String
            //   self.imageKeys.append(urlKey)
            self.imagesFromDB.append(downloadURL);
            
            
            
        })
        
        
        var URL_IMAGES_DB = "https://pickandroll-e0897.firebaseio.com/Albums/\(FIRAuth.auth()!.currentUser!.uid).json"
        
        let url = NSURL(string: URL_IMAGES_DB)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                if let userFolders = jsonObj as! NSArray as? [String] {
                    
                    for j in 0...userFolders.count-1 {
                        
                        self.items[0].append(userFolders[j])
                        
                    }
                }
                
                OperationQueue.main.addOperation({
                    
                })
                
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                })
                
                
            }
        }).resume()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomFolderCell
        
        
        //   var cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        // Configure the cell...
        cell.folderNameTextView.text = items[indexPath.section][indexPath.row]
        print(indexPath.section)
        cell.folderImageView?.image = UIImage(named:"folder")
        //  cell.imageCountTextField.text = String(self.imagesFromDB.count)
        cell.sharedUsersCount.text = sharedUsers
        
        folderName = items[indexPath.section][indexPath.row]
        folderIndex = indexPath.row
        
        
        
       // var dict : NSDictionary = [String : AnyObject]() as NSDictionary
        var dict = [String : AnyObject]()
        var newdict = [String : AnyObject]()
        
        for m in 0...self.imageKeys.count-1 {
            
            if((self.imageKeys[m].contains(folderName)) && (folderIndex == m)) {
                var folderImageArray = [String]()
                folderImageArray.append(self.imageKeys[m])
                
                // Initialize the Dictionary
                dict = [folderName: self.imageKeys[m] as NSString]
                cell.imageCountTextField.text = String(folderImageArray.count)
               
                print(dict[folderName]!)
                
            }
        }
        
      
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Albums").child(FIRAuth.auth()!.currentUser!.uid).child(String(folderIndex)).setValue(items[indexPath.section][indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var columnindex = String(indexPath.item)
        
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomFolderCell
        var folderText = currentCell.folderNameTextView!.text!
        
        var resultStr = "(\(columnindex)\(items[indexPath.section][indexPath.row]))"
        var folderImages = [String]()
        
        for k in 0...self.imageKeys.count-1 {
            if(self.imageKeys[k].contains(currentCell.folderNameTextView!.text!)){
                
                folderImages.append(self.imagesFromDB[k])
            }
            
        }
        
       /* for k in 0...self.imageKeys.count-1 {
            if((!(self.imageKeys[k].contains(userId))) && ((self.imageKeys[k].contains(userFolders[k])))){
                print(self.imageKeys[k])
                sharedUsersArray.append(self.imageKeys[k])
                
            }
            
        }
 */
        //  currentCell.imageCountTextField.text = String(folderImages.count)
        
     /*   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "showAlbum") as! PhotoFromAlbumsViewController
        nextViewController.imagesArryFolder = folderImages
        //nextViewController.selectedFolderNameIndex = resultStr
        self.present(nextViewController, animated:true, completion:nil)
        */
        
        print("curr text is :\(folderText)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "showUsers") as! UsersListViewController
        
        nextViewController.imagesFromFolder = folderImages
        print(folderImages.count)
        nextViewController.folderIndex = columnindex
        nextViewController.sharedfolderName = folderText
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
  
   
    
}

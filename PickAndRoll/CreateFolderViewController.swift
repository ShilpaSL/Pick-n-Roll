//
//  CreateFolderViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 27/06/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit


class CreateFolderViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate {

    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolBar: UIToolbar!
        
    let dataSource = DataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.leftBarButtonItem = editButtonItem
        toolBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let indexPath = getIndexPathForSelectedCell() {
            highlightCell(indexPath, flag: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- prepareForSegue
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // retrieve selected cell & fruit
//        
//        if let indexPath = getIndexPathForSelectedCell() {
//            
//            let fruit = dataSource.fruitsInGroup(indexPath.section)[indexPath.row]
//        
//            let detailViewController = segue.destination as! ELCImagePickerDemoViewController
//          //  detailViewController.fruit = fruit
//        }
//    }
//    
    // MARK:- Should Perform Segue
    
    
    
   
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    // MARK:- Selected Cell IndexPath
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if collectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    // MARK:- Highlight
    
    func highlightCell(_ indexPath : IndexPath, flag: Bool) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = UIColor.magenta
        } else {
            cell?.contentView.backgroundColor = nil
        }
    }
    
    // MARK:- Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView?.allowsMultipleSelection = editing
        toolBar.isHidden = !editing
    }
    
    // MARK:- Add Cell
    
    @IBAction func addNewItem(_ sender: AnyObject) {
        
        let index = dataSource.addAndGetIndexForNewItem()
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    
    @IBAction func deleteCells(_ sender: AnyObject) {
        
        var deletedFruits:[Fruit] = []
        
        let indexpaths = collectionView?.indexPathsForSelectedItems
        
        if let indexpaths = indexpaths {
            
            for item  in indexpaths {
                collectionView?.deselectItem(at: (item), animated: true)
                // fruits for section
                let sectionfruits = dataSource.fruitsInGroup(item.section)
                deletedFruits.append(sectionfruits[item.row])
            }
            
            dataSource.deleteItems(deletedFruits)
            
            collectionView?.deleteItems(at: indexpaths)
        }
    }
}

// MARK:- UICollectionView DataSource

extension CreateFolderViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numbeOfRowsInEachGroup(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! FruitCell
        
        let fruits: [Fruit] = dataSource.fruitsInGroup(indexPath.section)
        let fruit = fruits[indexPath.row]
        
        let name = fruit.name!
        
        cell.imageView.image = UIImage(named: "folder")
        cell.caption.text = "New Folder"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: FruitsHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! FruitsHeaderView
        
        headerView.sectionLabel.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
        
        return headerView
    }
}

// MARK:- UICollectionViewDelegate Methods

extension CreateFolderViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: true)
        print("collectionindex is-->\(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: false)
    }
}

extension CreateFolderViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
        
        let length = (UIScreen.main.bounds.width-15)/2
        return CGSize(width: length,height: length);
    }

    

 

}

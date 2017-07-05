//
//  DetailViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 09/10/16.
//  Copyright © 2017 CISPL. All rights reserved.

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var fruit: Fruit?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fruit = fruit {
            navigationItem.title = fruit.name?.capitalized
            imageView.image = UIImage(named: fruit.name!.lowercased())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

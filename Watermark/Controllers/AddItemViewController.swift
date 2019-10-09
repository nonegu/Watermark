//
//  AddItemViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("add item presented")
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            print("handle save here")
        }
    }
    
    
}

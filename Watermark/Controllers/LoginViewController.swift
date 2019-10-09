//
//  LoginViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginOrRegisterButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControlTextAttributes()
        loginOrRegisterButton.layer.cornerRadius = 5
    }
    
    @IBAction func loginOrRegisterPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginSuccess", sender: self)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? loginOrRegisterButton.setTitle("Login", for: .normal) : loginOrRegisterButton.setTitle("Register", for: .normal)
    }
    
    func setupSegmentedControlTextAttributes() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    
}

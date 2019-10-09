//
//  LoginViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginOrRegisterButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: Properties
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControlTextAttributes()
        loginOrRegisterButton.layer.cornerRadius = 5
    }
    
    @IBAction func loginOrRegisterPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Register" {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                print("invalid email or password")
                return
            }
            let newUser = User()
            newUser.username = email
            newUser.password = password
            
            register(user: newUser)
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? loginOrRegisterButton.setTitle("Login", for: .normal) : loginOrRegisterButton.setTitle("Register", for: .normal)
    }
    
    func setupSegmentedControlTextAttributes() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    func register(user: User) {
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("Error registering user \(error)")
        }
        
        performSegue(withIdentifier: "LoginSuccess", sender: self)
    }
    
    
}

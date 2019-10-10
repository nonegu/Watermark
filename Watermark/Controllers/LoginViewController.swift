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
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControlTextAttributes()
        loginOrRegisterButton.layer.cornerRadius = 5
    }
    
    @IBAction func loginOrRegisterPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("invalid email or password")
            return
        }
        if sender.titleLabel?.text == "Register" {
            let newUser = User()
            newUser.username = email
            newUser.password = password
            
            let users = realm.objects(User.self)
            if !users.contains(where: { (user) -> Bool in
                user.username == email
            }) {
                register(user: newUser)
            } else {
                print("user already exists")
            }
        } else {
            checkUserValidation(email: email, password: password)
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
    
    func checkUserValidation(email: String, password: String) {
        let users = realm.objects(User.self)
        if users.contains(where: { (user) -> Bool in
            user.username == email
        }) {
            user = users.first(where: { (user) -> Bool in
                user.password == password
            })
            if user == nil {
                print("wrong password")
            } else {
                performSegue(withIdentifier: "LoginSuccess", sender: self)
            }
        } else {
            print("user not found")
        }
    }
    
    
}
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
    @IBOutlet weak var rewritePasswordTextField: UITextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        rewritePasswordTextField.text = ""
    }
    
    @IBAction func loginOrRegisterPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("invalid email or password")
            return
        }
        // check if the email or password area is empty
        if email == "" || password == "" {
            displayAlert(title: "Invalid data", with: "E-mail or password can not be empty")
        } else {
            if sender.titleLabel?.text == "Register" {
                // check if given two passwords match
                if passwordTextField.text == rewritePasswordTextField.text {
                    let newUser = User()
                    newUser.username = email
                    newUser.password = password
                    
                    let users = realm.objects(User.self)
                    // check if username is already taken
                    if !users.contains(where: { (user) -> Bool in
                        user.username == email
                    }) {
                        register(user: newUser)
                    } else {
                        displayAlert(title: "Register Error", with: "User already exists")
                    }
                } else {
                    displayAlert(title: "Password Error", with: "Given passwords does not match.")
                }
            } else {
                checkUserValidation(email: email, password: password)
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? loginOrRegisterButton.setTitle("Login", for: .normal) : loginOrRegisterButton.setTitle("Register", for: .normal)
        
        if sender.selectedSegmentIndex == 0 {
            rewritePasswordTextField.isHidden = true
        } else {
            rewritePasswordTextField.isHidden = false
        }
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
            displayAlert(title: "Register Error", with: error.localizedDescription)
        }
        self.user = user
        performSegue(withIdentifier: "LoginSuccess", sender: self)
    }
    
    func checkUserValidation(email: String, password: String) {
        let users = realm.objects(User.self)
        if users.contains(where: { (user) -> Bool in
            user.username == email
        }) {
            user = users.first(where: { (user) -> Bool in
                user.username == email && user.password == password
            })
            if user == nil {
                displayAlert(title: "Login Error", with: "Wrong password")
            } else {
                performSegue(withIdentifier: "LoginSuccess", sender: self)
            }
        } else {
            displayAlert(title: "Login Error", with: "User not found")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! UINavigationController
        let homeVC = destination.topViewController as! HomeViewController
        homeVC.user = user
    }
    
    
}

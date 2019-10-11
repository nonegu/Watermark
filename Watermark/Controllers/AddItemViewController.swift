//
//  AddItemViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemCategory: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var addTodoButton: UIButton!
    
    // MARK: Properties
    let realm = try! Realm()
    var user: User?
    var category: Category?
    var allCategories: Results<Category>?
    let pickerView = UIPickerView()
    lazy var pickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 25))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(toolbarDoneButtonPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(toolbarCancelButtonPressed))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryTextField()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        dueDate.minimumDate = Date().addingTimeInterval(60)
        addTodoButton.layer.cornerRadius = 5
        print("add item presented")
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addTodoPressed(_ sender: UIButton) {
        if itemCategory.text != "" && isCategoryValid(categoryName: itemCategory.text!) {
            let newItem = Item()
            let parentCategory = category ?? allCategories?.first(where: { (category) -> Bool in
                category.name == itemCategory.text!
            })
            do {
                try realm.write {
                    newItem.title = itemTitle.text!
                    newItem.dueDate = dueDate.date
                    parentCategory?.items.append(newItem)
                }
            } catch {
                self.displayAlert(title: "Save Error", with: error.localizedDescription)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewCategoryPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentUser = self.user {
                do {
                    try self.realm.write {
                        let newCategory = Category()
                        newCategory.name = textField.text!
                        currentUser.categories.append(newCategory)
                    }
                    DispatchQueue.main.async {
                        self.pickerView.reloadAllComponents()
                    }
                } catch {
                    self.displayAlert(title: "Save Error", with: error.localizedDescription)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "e.g. Home"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupCategoryTextField() {
        if category == nil {
            allCategories = user?.categories.sorted(byKeyPath: "name")
            itemCategory.inputView = pickerView
            itemCategory.inputAccessoryView = pickerViewToolbar
        } else {
            itemCategory.text = category?.name
            itemCategory.isEnabled = false
        }
    }
    
    @objc func toolbarDoneButtonPressed() {
        let row = pickerView.selectedRow(inComponent: 0)
        itemCategory.text = allCategories![row].name
        itemCategory.resignFirstResponder()
    }
    
    @objc func toolbarCancelButtonPressed() {
        itemCategory.resignFirstResponder()
    }
    
    func isCategoryValid(categoryName: String) -> Bool {
        if self.category == nil {
            return allCategories!.contains { (category) -> Bool in
                category.name == categoryName
            }
        } else {
            return true
        }
    }
    
}

extension AddItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCategories?.count ?? 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if allCategories?.count == 0 {
            return "No categories added yet"
        } else {
            return allCategories?[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemCategory.text = allCategories![row].name
    }
    
    
}

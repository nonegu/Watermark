//
//  CategoryViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    let realm = try! Realm()
    var user: User?
    var categories: Results<Category>?
    var isCategoryEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: CategoryCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.defaultReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNavBar()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setupNavBar() {
        let addCategoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addCategoryButton.tintColor = UIColor.black
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        editButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [addCategoryButton, editButton]
    }
    
    func loadCategories() {
        categories = user?.categories.sorted(byKeyPath: "name", ascending: true)
    }
    
    @objc func addButtonPressed() {
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
                        self.collectionView.reloadData()
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
    
    @objc func editButtonPressed() {
        isCategoryEditing = !isCategoryEditing
        if isCategoryEditing {
            navigationItem.rightBarButtonItems?.last?.title = "Done"
            for cell in collectionView.visibleCells {
                if let categoryCell = cell as? CategoryCell {
                    categoryCell.shake()
                }
            }
        } else {
            navigationItem.rightBarButtonItems?.last?.title = "Edit"
            for cell in collectionView.visibleCells {
                if let categoryCell = cell as? CategoryCell {
                    categoryCell.stopShaking()
                }
            }
        }
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.defaultReuseIdentifier, for: indexPath) as! CategoryCell
        // if the cell is populated then there must be a category linked to it
        // so it is safe to force unwrap
        let category = categories![indexPath.row]
        cell.name.text = category.name
        if category.items.count > 0 {
            cell.completedItemsLabel.text = "\(numberOfCompletedItems(in: category))/\(category.items.count) Completed"
        } else {
            cell.completedItemsLabel.text = "No todos added"
        }
        cell.status.text = status(of: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (view.frame.width - 300) / 3
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCategoryEditing {
            guard let category = categories?[indexPath.row] else {
                print("Cannot found the category")
                return
            }
            var textField = UITextField()
            let alert = UIAlertController(title: "Update Category", message: "", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "Update", style: .default) { (action) in
                do {
                    try self.realm.write {
                        category.name = textField.text!
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    self.displayAlert(title: "Update Error", with: error.localizedDescription)
                }
            }
            let cancelAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    self.displayAlert(title: "Save Error", with: error.localizedDescription)
                }
            }
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            alert.addTextField { (field) in
                textField = field
                textField.text = self.categories?[indexPath.row].name
            }
            
            present(alert, animated: true, completion: nil)
        } else {
            let itemsVC = storyboard?.instantiateViewController(identifier: "ItemsVC") as! ItemsViewController
            itemsVC.category = categories?[indexPath.row]
            navigationController?.pushViewController(itemsVC, animated: true)
        }
    }
    
}

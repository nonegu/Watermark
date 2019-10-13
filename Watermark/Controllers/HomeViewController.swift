//
//  ViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 8.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    
    // MARK: Properties
    let realm = try! Realm()
    var user: User?
    var categories: Results<Category>?
    var todaysItems: Results<Item>?
    var itemToBeUpdated: Item?
    var userItems = [Results<Item>?]()
    var sectionTitles = [String]()
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        
        setupCollectionView()
        setupTableView()
        loadCategories()
        loadUserItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCollectionView.reloadData()
        loadUserItems()
        itemTableView.reloadData()
        subscribeToItemNotifications(selector: #selector(itemAddedOrUpdated))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToItemNotifications()
    }
    
    // MARK: Actions
    @IBAction func moreCategoriesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToCategories", sender: self)
    }
    
    @IBAction func moreTodosPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToItems", sender: self)
    }
    
    func setupCollectionView() {
        categoryCollectionView.register(UINib(nibName: CategoryCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.defaultReuseIdentifier)
        categoryCollectionView.register(UINib(nibName: AddCategoryCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: AddCategoryCell.defaultReuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    func setupTableView() {
        itemTableView.register(UINib(nibName: AddItemCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: AddItemCell.defaultReuseIdentifier)
        itemTableView.register(UINib(nibName: ItemCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemCell.defaultReuseIdentifier)
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func loadCategories() {
        categories = user?.categories.sorted(byKeyPath: "name", ascending: true)
        categoryCollectionView.reloadData()
    }
    
    func loadTodaysItems() {
        todaysItems = realm.objects(Item.self).filter("dueDate >= %@", Date()).filter("dueDate <= %@", Date().addingTimeInterval(24*3600)).sorted(byKeyPath: "dueDate")
    }
    
    func loadUserItems() {
        userItems.removeAll()
        sectionTitles.removeAll()
        guard let userCategories = categories else {
            print("could not load user categories")
            return
        }
        for category in userCategories {
            let items = category.items.filter("dueDate >= %@", Date()).filter("dueDate <= %@", Date().addingTimeInterval(24*3600)).filter("done = %@", false).sorted(byKeyPath: "dueDate")
            if items.count > 0 {
                userItems.append(items)
                sectionTitles.append(category.name)
            }
        }
    }
    
    // MARK: Return cell data for each section
    func cellData(for section: Int) -> Results<Item>? {
        return userItems[section - 1]
    }
    
    func setNavbarBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setNavbarBackButton()
        if segue.identifier == "HomeToCategories" {
            let categoryVC = segue.destination as! CategoryViewController
            categoryVC.user = user
        } else if segue.identifier == "HomeToAddItem" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.user = user
            addItemVC.item = itemToBeUpdated
        }
    }
    
    @objc func logoutPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func itemAddedOrUpdated() {
        loadUserItems()
        categoryCollectionView.reloadData()
        itemTableView.reloadData()
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return categories?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCell.defaultReuseIdentifier, for: indexPath) as! AddCategoryCell
            return cell
        } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
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
                            self.categoryCollectionView.reloadData()
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
        } else {
            setNavbarBackButton()
            let itemsVC = storyboard?.instantiateViewController(identifier: "ItemsVC") as! ItemsViewController
            itemsVC.category = categories?[indexPath.row]
            navigationController?.pushViewController(itemsVC, animated: true)
        }
    }
    
    
}


//
//  ItemsViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 10.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let realm = try! Realm()
    var category: Category?
    var user: User?
    var items: Results<Item>?
    var itemToBeUpdated: Item?
    var sectionTitles = [String]()
    var sectionItems = [Results<Item>?]()
    // defining filtered items to show in sections
    lazy var overdueItems = items?.filter("dueDate < %@", Date()).filter("done = %@", false)
    lazy var todaysItems = items?.filter("dueDate >= %@", Date()).filter("dueDate <= %@", Date().addingTimeInterval(24*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var tomorrowsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(48*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var weeksItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(48*3600)).filter("dueDate <= %@", Date().addingTimeInterval(7*24*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var monthsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(7*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(30*24*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var yearsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(30*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(365*24*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var otherItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(365*24*3600)).sorted(byKeyPath: "dueDate").filter("done = %@", false)
    lazy var completedItems = items?.filter("done = %@", true)
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ItemCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemCell.defaultReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        loadItems()
        loadSectionItems()
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToItemNotifications(selector: #selector(itemAddedOrUpdated))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToItemNotifications()
    }
    
    func loadItems() {
        if category == nil {
            sectionItems.removeAll()
            sectionTitles.removeAll()
            guard let categories = user?.categories else {
                return
            }
            for category in categories {
                if category.items.count > 0 {
                    sectionItems.append(category.items.sorted(byKeyPath: "dueDate"))
                    sectionTitles.append(category.name)
                }
            }
        } else {
            items = category!.items.sorted(byKeyPath: "dueDate")
        }
    }
    
    func loadSectionItems() {
        guard let allItems = items else {
            return
        }
        sectionItems.removeAll()
        sectionTitles.removeAll()
        if overdueItems!.count > 0 {
            sectionTitles.append("Overdue")
            sectionItems.append(overdueItems)
        }
        if todaysItems!.count > 0 {
            sectionTitles.append("Today")
            sectionItems.append(todaysItems)
        }
        if tomorrowsItems!.count > 0 {
            sectionTitles.append("Tomorrow")
            sectionItems.append(tomorrowsItems)
        }
        if weeksItems!.count > 0 {
            sectionTitles.append("In a week")
            sectionItems.append(weeksItems)
        }
        if monthsItems!.count > 0 {
            sectionTitles.append("In a month")
            sectionItems.append(monthsItems)
        }
        if yearsItems!.count > 0 {
            sectionTitles.append("In a year")
            sectionItems.append(yearsItems)
        }
        if otherItems!.count > 0 {
            sectionTitles.append("In the future")
            sectionItems.append(otherItems)
        }
        if completedItems!.count > 0 {
            sectionTitles.append("Completed")
            sectionItems.append(completedItems)
        }
        
        tableView.reloadData()
    }
    
    func setNavBar() {
        if category == nil {
            navigationItem.title = "All Items"
        } else {
            navigationItem.title = category?.name
        }
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addItemButton
        addItemButton.tintColor = UIColor.black
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: "ItemsToAdd", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsToAdd" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.user = user
            addItemVC.category = self.category
            addItemVC.item = self.itemToBeUpdated
        }
    }
    
    @objc func itemAddedOrUpdated() {
        loadSectionItems()
        tableView.reloadData()
    }
    
    // MARK: Return cell data for each section
    func cellData(for section: Int) -> Results<Item>? {
        if sectionItems.count > 0 {
            return sectionItems[section]
        }
        return nil
    }
    
    // MARK: Return number of items in each section
    func numberOfRows(for section: Int) -> Int {
        return cellData(for: section)?.count ?? 0
    }
    
    // MARK: Return title for each section
    func sectionTitle(for section: Int) -> String {
        return sectionTitles[section]
    }
    
}

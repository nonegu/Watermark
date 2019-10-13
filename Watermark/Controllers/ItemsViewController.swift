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
    lazy var todaysItems = items?.filter("dueDate >= %@", Date()).filter("dueDate <= %@", Date().addingTimeInterval(24*3600)).sorted(byKeyPath: "dueDate")
    lazy var tomorrowsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(48*3600)).sorted(byKeyPath: "dueDate")
    lazy var weeksItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(48*3600)).filter("dueDate <= %@", Date().addingTimeInterval(7*24*3600)).sorted(byKeyPath: "dueDate")
    lazy var monthsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(7*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(30*24*3600)).sorted(byKeyPath: "dueDate")
    lazy var yearsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(30*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(365*24*3600)).sorted(byKeyPath: "dueDate")
    lazy var otherItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(365*24*3600)).sorted(byKeyPath: "dueDate")
    
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
            items = realm.objects(Item.self)
        } else {
            items = category!.items.sorted(byKeyPath: "dueDate")
        }
    }
    
    func loadSectionItems() {
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
            addItemVC.category = self.category
            addItemVC.item = self.itemToBeUpdated
        }
    }
    
    @objc func itemAddedOrUpdated() {
        tableView.reloadData()
    }
    
    // MARK: Return cell data for each section
    func cellData(for section: Int) -> Results<Item>? {
        return sectionItems[section]
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

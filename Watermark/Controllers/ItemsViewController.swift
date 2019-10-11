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
    // defining filtered items to show in sections
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
        setNavBarTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadItems() {
        if category == nil {
            items = realm.objects(Item.self)
        } else {
            items = category!.items.sorted(byKeyPath: "dueDate")
        }
        tableView.reloadData()
    }
    
    func setNavBarTitle() {
        if category == nil {
            navigationItem.title = "All Items"
        } else {
            navigationItem.title = category?.name
        }
    }
    
    // MARK: Return cell data for each section
    func cellData(for indexPath: IndexPath) -> Results<Item>? {
        var cellData = items
        if indexPath.section == 0 {
            cellData = todaysItems
        } else if indexPath.section == 1 {
            cellData = tomorrowsItems
        } else if indexPath.section == 2 {
            cellData = weeksItems
        } else if indexPath.section == 3 {
            cellData = monthsItems
        } else if indexPath.section == 4 {
            cellData = yearsItems
        } else {
            cellData = otherItems
        }
        return cellData
    }
    
    // MARK: Return number of items in each section
    func numberOfRows(for section: Int) -> Int {
        if section == 0 {
            return todaysItems?.count ?? 0
        } else if section == 1 {
            return tomorrowsItems?.count ?? 0
        } else if section == 2 {
            return weeksItems?.count ?? 0
        } else if section == 3 {
            return monthsItems?.count ?? 0
        } else if section == 4 {
            return yearsItems?.count ?? 0
        } else {
            return otherItems?.count ?? 0
        }
    }
    
    // MARK: Return title for each section
    func sectionTitle(for section: Int) -> String {
        if section == 0 {
            return "Today"
        } else if section == 1 {
            return "Tomorrow"
        } else if section == 2 {
            return "In a week"
        } else if section == 3 {
            return "In a month"
        } else if section == 4 {
            return "In a year"
        } else {
            return "In the future"
        }
    }
    
}

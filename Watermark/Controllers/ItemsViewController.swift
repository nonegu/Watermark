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
    lazy var todaysItems = items?.filter("dueDate <= %@", Date().addingTimeInterval(24*3600)).sorted(byKeyPath: "dueDate")
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
    
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
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
        cell.itemTextLabel.text = cellData?[indexPath.row].title
        let dueHours = ((cellData?[indexPath.row].dueDate.timeIntervalSinceNow)! / 3600)
        cell.checkmarkImageView.isHidden = !(cellData?[indexPath.row].done)!
        cell.dueDate.text = "Due in: \(round(dueHours)) hours"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            print("Edit pressed")
            completion(true)
        }
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = UIColor.gray

        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            print("Delete pressed")
            completion(true)
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = UIColor.red

        return action
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
}

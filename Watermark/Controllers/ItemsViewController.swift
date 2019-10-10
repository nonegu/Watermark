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
            let todaysItems = items?.filter("dueDate <= %@", Date().addingTimeInterval(24*3600))
            return todaysItems?.count ?? 0
        } else if section == 1 {
            let tomorrowsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(48*3600))
            return tomorrowsItems?.count ?? 0
        } else if section == 2 {
            let weeksItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(48*3600)).filter("dueDate <= %@", Date().addingTimeInterval(7*24*3600))
            return weeksItems?.count ?? 0
        } else if section == 3 {
            let monthsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(7*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(30*24*3600))
            return monthsItems?.count ?? 0
        } else if section == 4 {
            let yearsItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(30*24*3600)).filter("dueDate <= %@", Date().addingTimeInterval(365*24*3600))
            return yearsItems?.count ?? 0
        } else {
            let otherItems = items?.filter("dueDate >= %@", Date().addingTimeInterval(365*24*3600))
            return otherItems?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
        cell.itemTextLabel.text = items?[indexPath.section].title
        let dueHours = ((items?[indexPath.section].dueDate.timeIntervalSinceNow)! / 3600)
        cell.checkmarkImageView.isHidden = !(items?[indexPath.section].done)!
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

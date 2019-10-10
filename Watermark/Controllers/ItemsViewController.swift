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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
        cell.itemTextLabel.text = items?[indexPath.row].title
        let dueHours = ((items?[indexPath.row].dueDate.timeIntervalSinceNow)! / 3600)
        cell.checkmarkImageView.isHidden = !(items?[indexPath.row].done)!
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
    
}

//
//  HomeViewController+TableView.swift
//  Watermark
//
//  Created by Ender Güzel on 8.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return todaysItems?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = itemTableView.dequeueReusableCell(withIdentifier: AddItemCell.defaultReuseIdentifier, for: indexPath) as! AddItemCell
            return cell
        } else {
            let cell = itemTableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
            let dueHours = ((todaysItems?[indexPath.row].dueDate.timeIntervalSinceNow)! / 3600)
            cell.itemTextLabel.text = todaysItems?[indexPath.row].title
            cell.checkmarkImageView.isHidden = !(todaysItems?[indexPath.row].done)!
            cell.dueDate.text = "Due in: \(round(dueHours)) hours"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Add new todo pressed")
            itemToBeUpdated = nil
            performSegue(withIdentifier: "HomeToAddItem", sender: self)
        } else {
            if let item = todaysItems?[indexPath.row] {
                do {
                    try realm.write {
                        item.done = !item.done
                    }
                } catch {
                    print("Error saving done status \(error)")
                }
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! ItemCell
            cell.checkmarkImageView.isHidden = !cell.checkmarkImageView.isHidden
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        } else {
            let edit = editAction(at: indexPath)
            let delete = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, edit])
        }
    }

    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.itemToBeUpdated = self.todaysItems?[indexPath.row]
            self.performSegue(withIdentifier: "HomeToAddItem", sender: self)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 60
        }
    }


}

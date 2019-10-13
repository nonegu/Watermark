//
//  ItemsViewController+TableView.swift
//  Watermark
//
//  Created by Ender Güzel on 11.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionItems.count > 0 {
            return sectionItems.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionItems.count > 0 {
            return numberOfRows(for: section)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
        if let data = cellData(for: indexPath.section) {
            cell.itemTextLabel.text = data[indexPath.row].title
            cell.emptyCheckmark.isHidden = false
            cell.checkmarkImageView.isHidden = !(data[indexPath.row].done)
            let dueHours = ((data[indexPath.row].dueDate.timeIntervalSinceNow) / 3600)
            let dueMinutes = dueHours.truncatingRemainder(dividingBy: 1) * 60
            var dueText = ""
            if dueHours > 1.0 && dueMinutes > 0.0 {
                dueText = "\(Int(dueHours)) hours \(Int(dueMinutes)) minutes"
            } else if dueHours < 1.0 {
                dueText = "\(Int(dueMinutes)) minutes"
            } else {
                dueText = "Overdue!"
            }
            cell.dueDate.text = "Due in: " + dueText
        } else {
            cell.itemTextLabel.text = "There are no todos."
            cell.emptyCheckmark.isHidden = true
            cell.checkmarkImageView.isHidden = true
            cell.dueDate.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = self.cellData(for: indexPath.section)
        if let item = cellData?[indexPath.row] {
            let cell = tableView.cellForRow(at: indexPath) as! ItemCell
            cell.checkmarkImageView.isHidden = !cell.checkmarkImageView.isHidden
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
            loadSectionItems()
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if sectionItems.count > 0 {
            let edit = editAction(at: indexPath)
            let delete = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, edit])
        } else {
            return nil
        }
    }

    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let cellData = self.cellData(for: indexPath.section)
            self.itemToBeUpdated = cellData?[indexPath.row]
            self.performSegue(withIdentifier: "ItemsToAdd", sender: self)
            completion(true)
        }
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = UIColor.gray

        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let cellData = self.cellData(for: indexPath.section)
            if let item = cellData?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("Error deleting item \(error)")
                }
            }
            self.loadSectionItems()
            self.tableView.reloadData()
            completion(true)
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = UIColor.red

        return action
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionItems.count > 0 {
            return sectionTitle(for: section)
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if header.textLabel?.text == "Overdue" {
            view.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else if header.textLabel?.text == "Completed" {
            view.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }else {
            view.tintColor = #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1)
        }
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
    }
    
}

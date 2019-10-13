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
        return 1 + sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return cellData(for: section)?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = itemTableView.dequeueReusableCell(withIdentifier: AddItemCell.defaultReuseIdentifier, for: indexPath) as! AddItemCell
            return cell
        } else {
            let cell = itemTableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
            let data = cellData(for: indexPath.section)
            let dueDays = ((data?[indexPath.row].dueDate.timeIntervalSinceNow)! / (24 * 3600))
            let dueHours = dueDays.truncatingRemainder(dividingBy: 1) * 24
            let dueMinutes = dueHours.truncatingRemainder(dividingBy: 1) * 60
            var dueText = ""
            if dueDays > 1.0 {
                dueText += "\(Int(dueDays)) days \(Int(dueHours)) hours \(Int(dueMinutes)) minutes"
            } else if dueHours > 1.0 && dueMinutes > 0.0 {
                dueText = "\(Int(dueHours)) hours \(Int(dueMinutes)) minutes"
            } else {
                dueText = "\(Int(dueMinutes)) minutes"
            }
            cell.itemTextLabel.text = data?[indexPath.row].title
            cell.checkmarkImageView.isHidden = !(data?[indexPath.row].done)!
            cell.dueDate.text = "Due in: " + dueText
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Add new todo pressed")
            itemToBeUpdated = nil
            performSegue(withIdentifier: "HomeToAddItem", sender: self)
        } else {
            if let item = cellData(for: indexPath.section)?[indexPath.row] {
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
            categoryCollectionView.reloadData()
            loadUserItems()
            itemTableView.reloadData()
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
            self.itemToBeUpdated = self.cellData(for: indexPath.section)?[indexPath.row]
            self.performSegue(withIdentifier: "HomeToAddItem", sender: self)
            completion(true)
        }
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = #colorLiteral(red: 0.4510940909, green: 0.3475753069, blue: 0.6542472243, alpha: 1)

        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let item = self.cellData(for: indexPath.section)?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("Error deleting item \(error)")
                }
            }
            self.itemTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return sectionTitles[section - 1]
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
    }

}

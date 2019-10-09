//
//  ViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 8.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    
    // MARK: Properties
    var categories: [UIColor] = [#colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1), #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1), #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1), #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1), #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1)]
    var dueDates: [Date] = [Date().addingTimeInterval(30 * 3600), Date().addingTimeInterval(21 * 3600), Date().addingTimeInterval(100 * 3600)]
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupCollectionView()
        setupTableView()
        
    }
    
    // MARK: Actions
    @IBAction func moreCategoriesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToCategories", sender: self)
    }
    
    @IBAction func moreTodosPressed(_ sender: UIButton) {
        print("more todos pressed")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCategories" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
        }
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
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCell.defaultReuseIdentifier, for: indexPath) as! AddCategoryCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.defaultReuseIdentifier, for: indexPath) as! CategoryCell
            cell.backgroundColor = categories[indexPath.row]
            cell.name.text = "Home"
            cell.completedItemsLabel.text = "1/3 Completed"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            categories.insert(UIColor.black, at:0)
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
    
    
}


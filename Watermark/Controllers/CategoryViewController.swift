//
//  CategoryViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var categories: [String] = ["Office", "Mall", "Gym", "Pets", "Kitchen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: CategoryCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.defaultReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNavBar()
        
    }
    
    func setupNavBar() {
        let addCategoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addCategoryButton
        addCategoryButton.tintColor = UIColor.black
    }
    
    @objc func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.categories.append(textField.text!)
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [IndexPath(item: (self.categories.count - 1), section: 0)])
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "e.g. Home"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.defaultReuseIdentifier, for: indexPath) as! CategoryCell
        cell.name.text = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (view.frame.width - 300) / 3
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    
}
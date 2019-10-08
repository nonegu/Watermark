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
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        categoryCollectionView.register(UINib(nibName: CategoryCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.defaultReuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    // MARK: Actions
    @IBAction func moreCategoriesPressed(_ sender: UIButton) {
        print("more categories pressed")
    }
    
    @IBAction func moreTodosPressed(_ sender: UIButton) {
        print("more todos pressed")
    }
    
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.defaultReuseIdentifier, for: indexPath) as! CategoryCell
        cell.name.text = "Home"
        cell.completedItemsLabel.text = "1/3 Completed"
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    
}


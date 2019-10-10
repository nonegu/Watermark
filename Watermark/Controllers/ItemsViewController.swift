//
//  ItemsViewController.swift
//  Watermark
//
//  Created by Ender Güzel on 10.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ItemCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ItemCell.defaultReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.defaultReuseIdentifier, for: indexPath) as! ItemCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

//
//  UICollectionView+Helpers.swift
//  Watermark
//
//  Created by Ender Güzel on 12.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension UICollectionViewDataSource {
    
    func numberOfCompletedItems(in category: Category) -> Int{
        var completedItems = 0
        for item in category.items {
            if item.done {
                completedItems += 1
            }
        }
        return completedItems
    }
    
    func status(of category: Category) -> String {
        if category.items.count > 0 {
            if numberOfCompletedItems(in: category) < category.items.count {
                return "In Progress"
            } else {
                return "Completed"
            }
        } else {
            return ""
        }
    }
    
}

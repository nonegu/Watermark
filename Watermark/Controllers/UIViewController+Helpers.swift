//
//  UIViewController+Helpers.swift
//  Watermark
//
//  Created by Ender Güzel on 10.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Alerts
    func displayAlert(title: String, with message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func subscribeToItemNotifications(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: .didAddOrUpdateItem, object: nil)
    }
    
    func unsubscribeToItemNotifications() {
        NotificationCenter.default.removeObserver(self, name: .didAddOrUpdateItem, object: nil)
    }
    
}

extension Notification.Name {
    static let didAddOrUpdateItem = Notification.Name("didAddOrUpdateItem")
}

//
//  User.swift
//  Watermark
//
//  Created by Ender Güzel on 9.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var username: String?
    @objc dynamic var password: String?
    let categories = List<Category>()
}

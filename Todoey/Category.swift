//
//  Category.swift
//  Todoey
//
//  Created by Hoda Moustapha on 5/4/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import Foundation
import RealmSwift


// * * * * * * * * * * * * * * * * * * * * * * * *
class Category: Object
{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    let toDoItems = List<ToDoItem>()
    
} // * * * * * end

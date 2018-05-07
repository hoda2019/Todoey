//
//  Data.swift
//  Todoey
//
//  Created by Hoda Moustapha on 5/4/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import Foundation
import RealmSwift

// * * * * * * * * * * * * * * * * * * * * * * * *
class ToDoItem: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "toDoItems")
    
}// * * * end

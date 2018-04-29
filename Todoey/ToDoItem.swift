//
//  ToDoItem.swift
//  Todoey
//
//  Created by Hoda Moustapha on 4/28/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import Foundation

// * * * * * * * * * * * * * *  begin class
class ToDoItem : Encodable, Decodable
{
    var name = "" ;
    var completed: Bool = false;
    
    // + - + - + - + - + - + - + - + - +
    init(text:String)
    {
        name = text;
    }
} // * * * * * * * * * end class





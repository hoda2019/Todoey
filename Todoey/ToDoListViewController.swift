//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Hoda Moustapha on 4/27/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit

// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class ToDoListViewController: UITableViewController
{
    // % % % % % % % % % % % % % % % %
    //var itemArray = ["Get Milk", "Complete IOS Todoey", "Complete Perspective", "Wash Dishes" ];
    
    var itemArray = [ToDoItem]();
    
    let defaults = UserDefaults.standard;
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        itemArray.append(ToDoItem (text: "Save the world"));
        itemArray.append(ToDoItem (text: "Eat SPinach"));
        itemArray.append(ToDoItem (text: "Cook Zuchini"));
        itemArray.append(ToDoItem (text: "Go Gym"));
        itemArray.append(ToDoItem (text: "Eat Pizza"));
        itemArray.append(ToDoItem (text: "Wash Dishes"));
        
        itemArray.append(ToDoItem (text: "aaa"));
        itemArray.append(ToDoItem (text: "bbb"));
        itemArray.append(ToDoItem (text: "ccc"));
        itemArray.append(ToDoItem (text: "ddd"));
        itemArray.append(ToDoItem (text: "eee"));
        itemArray.append(ToDoItem (text: "fff"));
            
        itemArray.append(ToDoItem (text: "ggg"));
        itemArray.append(ToDoItem (text: "hhh"));
        itemArray.append(ToDoItem (text: "iii"));
        itemArray.append(ToDoItem (text: "jjj"));
        itemArray.append(ToDoItem (text: "kkk"));
        itemArray.append(ToDoItem (text: "lll"));
            
        //if let retreivedItems = defaults.array(forKey: "ToDoListArray") as? [ToDoItem]
         //{ itemArray = retreivedItems; }
        
        //if let items = defaults.array(forKey: "ToDoListArray") as? [String]
        //{ itemArray = items; }
        
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - tableView DataSource Methods
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let currentItem = itemArray[indexPath.row];
            
        cell.textLabel?.text = currentItem.name;
        
        //if (currentItem.completed == true)  { cell.accessoryType = .checkmark}
        //else {  cell.accessoryType = .none  }
        
        cell.accessoryType = currentItem.completed ? .checkmark: .none;
        
        return cell;
    }
    
   // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count;
    }
  
    //MARK - tableView Delegate Methods
     // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(itemArray[indexPath.row]);
        
        let currentItem = self.itemArray[indexPath.row];
        
        currentItem.completed = !(currentItem.completed);
      
        
//        if ( currentItem.completed == true)
//        {
//             currentItem.completed = false;
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
//        }
//        else
//        {
//            currentItem.completed = true;
//              tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
//        }
        
        self.tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
 //MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {  (action) in
            
            
            let newItem = ToDoItem (text: textField.text!);
            self.itemArray.append(newItem);
            
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray");
           self.tableView.reloadData();
       
        }
        
        alert.addTextField
        {
            (alertTextField) in
            alertTextField.placeholder = "Create new Item";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        present (alert, animated: true, completion: nil)
        
    }
    
}// * * * * * * * * * * * *  end class


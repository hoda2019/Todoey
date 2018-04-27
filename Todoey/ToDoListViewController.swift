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
    var itemArray = ["Get Milk", "Complete IOS Todoey", "Complete Perspective", "Wash Dishes" ];
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        cell.textLabel?.text = itemArray[indexPath.row];
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
        
    
       
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark)
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
 //MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            self.itemArray.append(textField.text!);
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


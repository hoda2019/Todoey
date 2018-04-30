//
//  ToDoListViewController.swift
//  Todoey
//  4/30/18
//  Created by Hoda Moustapha on 4/27/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit

// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class ToDoListViewController: UITableViewController
{
    // % % % % % % % % % % % % % % % %
    var itemArray = [ToDoItem]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ;
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        itemArray.append(ToDoItem (text: "Save the world"));
//        itemArray.append(ToDoItem (text: "Eat SPinach"));
//        itemArray.append(ToDoItem (text: "Cook Zuchini"));
//        itemArray.append(ToDoItem (text: "Go Gym"));
//        itemArray.append(ToDoItem (text: "Eat Pizza"));
//        itemArray.append(ToDoItem (text: "Wash Dishes"));
        
        //print (dataFilePath) ;
        
        loadItems();
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
        //print(itemArray[indexPath.row]);
        
        let currentItem = self.itemArray[indexPath.row];
        
        currentItem.completed = !(currentItem.completed);
        
         saveItems();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
 //MARK - add new item
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {  (action) in
            
            
            let newItem = ToDoItem (text: textField.text!);
            self.itemArray.append(newItem);
        
            self.saveItems();
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
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func saveItems()
    {
        let encoder = PropertyListEncoder();
        
        do
        {
            let data = try encoder.encode(itemArray);
            try data.write(to: dataFilePath!);
        }
        catch
        {
            print ("error encoding item array, \(error)");
        }
    
        self.tableView.reloadData();
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder();
            do
            {
                itemArray = try decoder.decode([ToDoItem].self, from: data);
            }
            catch
            {
                print ("error decoding item array, \(error)");
            }
        }
    }
}// * * * * * * * * * * * *  end class


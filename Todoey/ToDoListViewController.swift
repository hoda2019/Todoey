//
//  ToDoListViewController.swift
//  Todoey
//  4/30/18
//  Created by Hoda Moustapha on 4/27/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit
import CoreData


// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class ToDoListViewController: UITableViewController
{
    // % % % % % % % % % % % % % % % %
    var itemArray = [ToDoItem]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    let dataContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext ;
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        //print (dataFilePath) ;
        
        loadItems();
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////
    //MARK: - tableView DataSource Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row];
            
        cell.textLabel?.text = currentItem.title;
        
        //if (currentItem.completed == true)  { cell.accessoryType = .checkmark}
        //else {  cell.accessoryType = .none  }
        cell.accessoryType = currentItem.completed ? .checkmark: .none;
        
        return cell;
    }
    
   // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count;
    }
    
    ////////////////////////////////////////////////
    //MARK: - tableView Delegate Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let currentItem = self.itemArray[indexPath.row];
        
        currentItem.completed = !(currentItem.completed);
        
        // code for delete
        //dataContext.delete(currentItem)
        //itemArray.remove(at: indexPath.row);
        
        saveItems();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    ////////////////////////////////////////////////
    //MARK: - add new item
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {  (action) in
            
            
            
            let newItem = ToDoItem(context: self.dataContext);
            
            newItem.title = textField.text! ;
            newItem.completed = false ;
            
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
    
    ////////////////////////////////////////////////
    //MARK: - Save and load Items
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func saveItems()
    {
        do
        {
            try dataContext.save() ;
        }
        catch
        {
            print ("error saving context, \(error)");
        }
        self.tableView.reloadData();
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadItems()
    {
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest();
        do
        {
            itemArray = try dataContext.fetch(request);
        }
        catch
        {
            print ("error loading from the context , \(error)");
        }
    
    }
    
}// * * * * * * * * * * * *  end class


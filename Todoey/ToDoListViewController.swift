//
//  ToDoListViewController.swift
//  Todoey
//  5/2/18
//  Created by Hoda Moustapha on 4/27/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit
import RealmSwift


// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class ToDoListViewController: UITableViewController
{
    // % % % % % % % % % % % % % % % %
    var toDoItemList : Results <ToDoItem>?
    @IBOutlet weak var navItem: UINavigationItem! // for the title of the page
    
    var selectedCategory: Category?
    {
        didSet
        {
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadItems()
    {
        toDoItemList = selectedCategory?.toDoItems.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData();
    }

    ////////////////////////////////////////////////
    //MARK: - tableView DataSource Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toDoItemList?.count ?? 1;
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let currentItem = toDoItemList?[indexPath.row]
        {
            cell.textLabel?.text = currentItem.title;
            
            if (currentItem.completed == true)  { cell.accessoryType = .checkmark}
            else {  cell.accessoryType = .none  }
            cell.accessoryType = currentItem.completed ? .checkmark: .none;
        }
        else
        {
            cell.textLabel?.text = "No Items Yet"
        }
        
        return cell;
    }
 
    ////////////////////////////////////////////////
    //MARK: - tableView Delegate Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let currentItem = self.toDoItemList?[indexPath.row]
        {
            do {
                try self.realm.write
                {
                    currentItem.completed = !currentItem.completed;
                    //realm.delete(currentItem)
                }
            }
            catch { print ("error updating completion, \(error)")}
        }
        
        tableView.reloadData()
        
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

            if let currentCategory = self.selectedCategory
            {
                do {
                    try self.realm.write
                    {
                        let newItem = ToDoItem();  
                        newItem.title = textField.text! ;
                        newItem.dateCreated = Date();
                        self.realm.add(newItem)
                        currentCategory.toDoItems.append(newItem)
                    }
                }
                catch { print ("error saving into realm, \(error)")}
                
                self.tableView.reloadData()
            }
        }

        alert.addTextField
        {  (alertTextField) in
            
            alertTextField.placeholder = "Create new Item";
            textField = alertTextField;
        }

        alert.addAction(action);
        present (alert, animated: true, completion: nil)
        
    }
    
}// * * * * * * * * * * * *  end class

////////////////////////////////////////////////
//MARK: - Search Functions
////////////////////////////////////////////////

// * * * * * * * * * * * *  Begin Extension
extension ToDoListViewController: UISearchBarDelegate
{
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        toDoItemList = toDoItemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData();
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count == 0)
        {
            loadItems();
            DispatchQueue.main.async { searchBar.resignFirstResponder(); }
        }
    }

}// * * * * * * * *  end Extension


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
    var selectedCategory: Category? { didSet { loadItems() } }
    
    @IBOutlet weak var navItem: UINavigationItem! // for the title of the page
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    let dataContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext ;
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        //print (dataFilePath) ;
        //loadItems();
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
            newItem.parentCategory = self.selectedCategory;
            
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
        do { try dataContext.save() }
        catch { print ("error saving context, \(error)")}
        
        self.tableView.reloadData()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // combines the search predictate (if it exists) to the category predicate 
        if let searchPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do  { itemArray = try dataContext.fetch(request); }
        catch  { print ("error fetching data from the context , \(error)");}
        
        tableView.reloadData();
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
       //print ( "searchBarSearchButtonClicked" );
       //print ( searchBar.text!);
        
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest();
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        
        loadItems(with: request, predicate: predicate);
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

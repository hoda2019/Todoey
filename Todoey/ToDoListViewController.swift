//
//  ToDoListViewController.swift
//  Todoey
//  5/2/18
//  Created by Hoda Moustapha on 4/27/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class ToDoListViewController: SwipeTableViewController
{
    // % % % % % % % % % % % % % % % %
    var toDoItemList : Results <ToDoItem>?
    @IBOutlet weak var navItem: UINavigationItem! // for the title of the page
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        navItem.title = selectedCategory?.name ?? "NewList"
    }
    
     // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewWillAppear(_ animated: Bool)
    {
        guard let colHex = selectedCategory?.color else { (fatalError ("Category does not exist!")) }
        updateNavBar(withHexCode: colHex)
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewWillDisappear(_ animated: Bool)
    {
        updateNavBar(withHexCode: "7FA8E6")
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func updateNavBar(withHexCode colorHexCode: String)
    {
        guard let navBar = navigationController?.navigationBar else
        { fatalError ("Navigation controller does not exist!") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else
        { fatalError ("Color does not exist!") }
        
        searchBar.barTintColor = navBarColor
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:
            ContrastColorOf(navBarColor, returnFlat: true)]
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
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func saveItems(text:String)
    {
        if let currentCategory = self.selectedCategory
        {
            do {
                try self.realm.write
                {
                    let newItem = ToDoItem();
                    newItem.title = text ;
                    newItem.dateCreated = Date();
                    self.realm.add(newItem)
                    currentCategory.toDoItems.append(newItem)
                }
            }
            catch { print ("error saving into realm, \(error)")}
            
            self.tableView.reloadData()
        }
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
        // superclass sets the swipeable features
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
  
        //this class sets the cell information and color
        if let currentItem = toDoItemList?[indexPath.row] // if the item exists
        {
            cell.textLabel?.text = currentItem.title;
            
            //if (currentItem.completed == true)  { cell.accessoryType = .checkmark}
            //else {  cell.accessoryType = .none  }
            cell.accessoryType = currentItem.completed ? .checkmark: .none;
            
            //if we can create a color based on the hex string
            // set the gradation percent and the text color
            if let basecolor = UIColor(hexString: selectedCategory?.color ?? "7FA8E6")
            {
                let newcolor = basecolor.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItemList!.count))
                cell.backgroundColor = newcolor
                cell.textLabel?.textColor = ContrastColorOf(newcolor!, returnFlat: true)
            }
        }
        else { cell.textLabel?.text = "No Items Yet" }
        
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

            self.saveItems(text: textField.text!)
        }

        alert.addTextField
        {  (alertTextField) in
            
            alertTextField.placeholder = "Create new Item";
            textField = alertTextField;
        }

        alert.addAction(action);
        present (alert, animated: true, completion: nil)
        
    }
// + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func updateModel(at indexPath: IndexPath)
    {
        if let currentItem = self.toDoItemList?[indexPath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(currentItem)
                }
            }
            catch { print ("error deleting to do item, \(error)")}
        }
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


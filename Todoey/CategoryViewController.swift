//
//  CategoryViewController.swift
//  Todoey
//  5/2/18
//  Created by Hoda Moustapha on 5/1/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class CategoryViewController: SwipeTableViewController
{
    // % % % % % % % % % % % % % % % %
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCategories()
        
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadCategories()
    {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func save(category:Category)
    {
        do
        {
            try realm.write
            {
                realm.add(category)
            }
        }
        catch { print ("error saving into realm \(error)") }
        
        tableView.reloadData()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func updateModel(at indexPath: IndexPath)
    {
        if let currentCat = self.categoryArray?[indexPath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(currentCat)
                }
            }
            catch { print ("error deleting category, \(error)") }
        }
    }
    
    ////////////////////////////////////////////////
    //MARK: - tableView DataSource Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray?.count ?? 1;
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // superclass creates cell with swipable features
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // this class puts data info into the cell
        if let category = categoryArray?[indexPath.row]
        {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }

        return cell
    }

    ////////////////////////////////////////////////
    //MARK: - tableView Add new category
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        // create a text field
        var textField = UITextField()
        
        // create an alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create an action  // closure
        let action = UIAlertAction(title: "Add Category", style: .default)
        { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color =  UIColor.randomFlat.hexValue()
        
            self.save(category: newCategory)
        }
        
        // add the action to the alert
        alert.addAction(action)
        
        // add the textfield to the alert  // closure
        alert.addTextField
        { (field) in
            
            field.placeholder = "Create New Category"
            textField = field
        }
        
        present(alert,animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////
    //MARK: - tableView Delegate Methods - SEGUE
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
       
        // if we have a row selected, set the category of the item view controller
        if let indexpath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray?[indexpath.row]
        }
    }
    
}// * * * * * * * * * * * *  end class




//
//  CategoryViewController.swift
//  Todoey
//  5/2/18
//  Created by Hoda Moustapha on 5/1/18.
//  Copyright © 2018 Hoda Moustapha. All rights reserved.
//

import UIKit
import CoreData

// * * * * * * * * * * * * * * * * * * * * * * * * begin class
class CategoryViewController: UITableViewController
{
    // % % % % % % % % % % % % % % % %
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadCategories();
        
        //print (dataFilePath)

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    ////////////////////////////////////////////////
    //MARK: - tableView DataSource Methods
    ////////////////////////////////////////////////
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count;
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name;
        return cell
     }
    
    ////////////////////////////////////////////////
    //MARK: - tableView Data Manipulation Methods
    ////////////////////////////////////////////////
      // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func loadCategories()
    {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do  { categoryArray = try dataContext.fetch(request) }
        catch { print ("error fetching data from context \(error)") }
        
        tableView.reloadData()
    }
    
    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    func saveCategories()
    {
        do  { try dataContext.save() }
        catch { print ("error saving context \(error)") }
        
        tableView.reloadData()
        
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
            let newCategory = Category(context: self.dataContext)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
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
    //MARK: - tableView Delegate Methods
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
       
        // if we have a row selected
        // set the category and the title of the item view controller
        if let indexpath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray[indexpath.row]
            destinationVC.navItem.title = categoryArray[indexpath.row].name
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }*/
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Table view data source 2
    //    // + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
}// * * * * * * * * * * * *  end class

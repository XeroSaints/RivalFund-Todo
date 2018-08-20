//
//  ViewController.swift
//  RivalFund Todo
//
//  Created by X on 8/13/18.
//  Copyright © 2018 Xavier Santos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item on our UI Alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
    }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
}
    
        //Mark - Model Manupulation Methods
        
        func saveItems() {
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(itemArray)
                try data.write(to: dataFilePath!)
            } catch {
                print("Error in coding item array, \(error)")
            }
            
            self.tableView.reloadData()
        }
        
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decorder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
        
    
}

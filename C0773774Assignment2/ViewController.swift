//
//  ViewController.swift
//  C0773774Assignment2
//
//  Created by Nitin on 19/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Properties
    let persistent = PersistenceManager.shared
    var tasksList: [Tasks]!
    var task: Tasks?
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initViews()
    }
    
    // MARK: - Action
    @IBAction func addBtnClicked(_ sender: Any) {
        // navigate...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.editBool = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Helper
    func initViews() {
        //
        persistent.fetch(type: Tasks.self) { (tasks) in
            self.tasksList = tasks
            self.tableView.reloadData()
            
        }
    }
    
    private var cellClass: VCTableViewCell.Type {
        return VCTableViewCell.self
    }
    
    func addDay() {
        
    }
    
    func deleteTask() {
        //
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"title == %@", task?.title ?? "")
        
        do{
            let searchResults = try PersistenceManager.getContext().fetch(fetchRequest)
            if(searchResults.count > 0){
                print("Error")
                
                let context = PersistenceManager.getContext()
                for object in searchResults {
                    context.delete(object)
                }
                
                do{
                    try context.save()
                    
                    self.initViews()
                }catch{
                    print("Error")
                }
            }else{
                print("Error")
            }
        }
        catch{
            print("Error \(error)")
            
        }
    }
    
    func checkForUpdate() -> Bool {
        //
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"title == %@", task?.title ?? "")
        
        do{
            let searchResults = try PersistenceManager.getContext().fetch(fetchRequest)
            if(searchResults.count > 0){
                
                return true
                
            }else{
                return false
            }
            //print(searchResults.count)
        }
        catch{
            print("Error \(error)")
            return false
            
        }
    }
    
    
    func updateToCoreData() {
        if checkForUpdate() {
            persistent.fetch(type: Tasks.self) { (tasks) in
                for ntask in tasks {
                    if ntask.title == self.task?.title {
                        let days = Int(self.task?.daysAdd ?? "0")! + 1
                        ntask.daysAdd = String(format: "%d", days)
                        do{
                            try self.persistent.context.save()
                            
                            self.initViews()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            }
        }else{
            self.showAlert(title: "C0773774", message: "Error!")
        }
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as? VCTableViewCell)!
        cell.task = tasksList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellClass.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // navigate...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.editBool = true
        
        if Int(tasksList[indexPath.row].totalDays ?? "0")! > Int(tasksList[indexPath.row].daysAdd ?? "0")!{
            vc.compBool = false
        }else{
            vc.compBool = true
        }
        
        vc.task = tasksList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            //            self.tableArray.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            self.task = self.tasksList[indexPath.row]
            self.deleteTask()
        }
        
        let addD = UITableViewRowAction(style: .default, title: "Add Day") { (action, indexPath) in
            // share item at indexPath
            // print("I want to share: \(self.tableArray[indexPath.row])")
            self.task = self.tasksList[indexPath.row]
            self.updateToCoreData()
        }
        
        addD.backgroundColor = UIColor.green
        
        if Int(tasksList[indexPath.row].totalDays ?? "0")! > Int(tasksList[indexPath.row].daysAdd ?? "0")!{
            return [delete, addD]
        }else{
            return [delete]
        }
        
        
    }
    
}


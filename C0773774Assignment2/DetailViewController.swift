//
//  DetailViewController.swift
//  C0773774Assignment2
//
//  Created by Nitin on 19/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var strDateTime = String()
    let persistent = PersistenceManager.shared
    var editBool = Bool()
    var task: Tasks?
    
    var compBool = Bool()
    
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var totalDaysTextField: UITextField!
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var saveBtn: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        //
        if checkValidation() {
            if editBool {
                if Int(totalDaysTextField.text!) ?? 0 < Int((task?.daysAdd!)!) ?? 0 {
                    updateToCoreData(comp: true)
               } else {
                    updateToCoreData(comp: false)
               }

            }else{
                saveToCoreData()
            }
            
        }else{
            self.showAlert(title: "C0773774", message: "All fields are required")
        }
    }
    
    // MARK: - Helper
    func showCustAlert(msg: String) {
        let alert = UIAlertController(title: "C0773774", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            action in
            
            //
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func initViews() {
        if compBool == true {
            saveBtn.isHidden = true
        }else{
            saveBtn.isHidden = false
        }
        
        if(editBool == true){
            
            dateLbl.text = task?.date ?? ""
            titleTextField.text = task?.title ?? ""
            totalDaysTextField.text = task?.totalDays ?? ""
            descTextView.textColor = UIColor.black
            descTextView.text = task?.descrip ?? ""
            
        }else{
            descTextView.text = "Tap here to add your description..."
            descTextView.textColor = UIColor.darkGray
            
            let date = Date()
            // date
            let dformatter = DateFormatter()
            dformatter.dateFormat = "d MMM"
            let stDate = dformatter.string(from: date)
            
            // day
            let eformatter = DateFormatter()
            eformatter.dateFormat = "EEEE"
            let stDay = eformatter.string(from: date)
            
            dateLbl.text = currentDate()
        }
    }
    
    func currentDate() -> String{
        let date = Date()
        // date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "d MMM"
        let stDate = dformatter.string(from: date)
        
        // day
        let eformatter = DateFormatter()
        eformatter.dateFormat = "EEEE"
        let stDay = eformatter.string(from: date)
        
        return String(format: "%@, %@", stDay, stDate)
        
    }
    
    func checkValidation() -> Bool {
        if(descTextView.text != "" || descTextView.text != "Tap here to add your description..."  && titleTextField.text != "" && totalDaysTextField.text != "" && Int(totalDaysTextField.text ?? "0")! > 0){
            return true
        }else{
            return false
        }
    }
    
    func saveToCoreData() {
        //
        let user = Tasks(context: persistent.context)
        user.date = currentDate()
        let timestamp = NSDate().timeIntervalSince1970
        user.timestamp = String(format: "%f",timestamp)
        user.daysAdd = "0"
        user.descrip = descTextView.text
        user.title = titleTextField.text
        user.totalDays = totalDaysTextField.text
        do{
            try persistent.context.save()
            
            showCustAlert(msg: "Data Saved to List.")
        } catch {
            print(error.localizedDescription)
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
    
    
    func updateToCoreData(comp: Bool) {
        if checkForUpdate() {
            persistent.fetch(type: Tasks.self) { (tasks) in
                for ntask in tasks {
                    if ntask.title == self.task?.title {
                        ntask.date = self.currentDate()
                        ntask.descrip = self.descTextView.text
                        ntask.title = self.titleTextField.text
                        if comp {
                            ntask.totalDays = self.task?.daysAdd
                        } else{
                            ntask.totalDays = self.totalDaysTextField.text
                        }
                        
                        let timestamp = NSDate().timeIntervalSince1970
                        ntask.timestamp = String(format: "%f",timestamp)
                        do{
                            try self.persistent.context.save()
                            
                            self.showCustAlert(msg: "Data Updated to List.")
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

// MARK: - UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == ""){
            textView.text = "Tap here to add your description..."
            textView.textColor = UIColor.darkGray
        }
    }
}

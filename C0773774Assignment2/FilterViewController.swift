//
//  FilterViewController.swift
//  C0773774Assignment2
//
//  Created by Nitin on 21/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet var dateFilter: UISwitch!
    @IBOutlet var titleFilter: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterByTitleSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            sender.isOn = true
            dateFilter.isOn = false
            
            Singelton.sharedObj.sortByTitle = true
            Singelton.sharedObj.sortByDate = false
        }else{
            sender.isOn = false
            dateFilter.isOn = true
            
            Singelton.sharedObj.sortByTitle = false
            Singelton.sharedObj.sortByDate = true
        }
        
    }
    
    @IBAction func filterByDateSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            sender.isOn = true
            titleFilter.isOn = false
            
            Singelton.sharedObj.sortByTitle = false
            Singelton.sharedObj.sortByDate = true
        }else{
            sender.isOn = false
            titleFilter.isOn = true
            
            Singelton.sharedObj.sortByTitle = true
            Singelton.sharedObj.sortByDate = false
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

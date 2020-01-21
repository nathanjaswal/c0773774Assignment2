//
//  Helper.swift
//  C0773774Assignment2
//
//  Created by Nitin on 20/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit


class Singelton {
    
    static let sharedObj = Singelton()
    
    var sortByTitle: Bool?
    var sortByDate: Bool?
}

extension UIViewController {
    
    ///
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


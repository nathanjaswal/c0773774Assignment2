//
//  DetailTableViewCell.swift
//  C0773774Assignment2
//
//  Created by Nitin on 19/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VCTableViewCell: UITableViewCell {
    
    // MARK: - Proprties
    static var reuseId: String {
        return String(describing: self)
    }
    
    @IBOutlet var compImg: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var dateTimeLbl: UILabel!
    
    @IBOutlet var totalDaysLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    
    var task: Tasks? {
        didSet {
            guard let task = task else { return }
            titleLbl.text = task.title
            dateTimeLbl.text = task.date
            totalDaysLabel.text = task.totalDays
            daysLabel.text = task.daysAdd
            
            if Int(task.totalDays!) == Int(task.daysAdd!) {
                compImg.isHidden = false
            }else{
                compImg.isHidden = true
            }
            
        }
    }
    
    static var cellHeight: CGFloat {
        return 90.0
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

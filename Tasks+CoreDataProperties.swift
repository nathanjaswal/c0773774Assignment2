//
//  Tasks+CoreDataProperties.swift
//  
//
//  Created by Nitin on 21/01/20.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var date: String?
    @NSManaged public var daysAdd: String?
    @NSManaged public var descrip: String?
    @NSManaged public var title: String?
    @NSManaged public var totalDays: String?
    @NSManaged public var timestamp: String?

}

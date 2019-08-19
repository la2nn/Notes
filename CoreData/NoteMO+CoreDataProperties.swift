//
//  NoteMO+CoreDataProperties.swift
//  Notes
//
//  Created by Николай Спиридонов on 19/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteMO> {
        return NSFetchRequest<NoteMO>(entityName: "NoteMO")
    }

    @NSManaged public var uid: String
    @NSManaged public var title: String
    @NSManaged public var content: String
    @NSManaged public var importance: String
    @NSManaged public var noteColor: NSObject
    @NSManaged public var destuctionDate: NSDate?
    @NSManaged public var lastUpdate: NSDate?

}

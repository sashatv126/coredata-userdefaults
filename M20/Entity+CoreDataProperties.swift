//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Владимир on 14.03.2022.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birth: Int64
    @NSManaged public var country: String?

}

//
//  DBNote+CoreDataProperties.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//
//

import Foundation
import CoreData


extension DBNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBNote> {
        return NSFetchRequest<DBNote>(entityName: "DBNote")
    }

    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var completed: Bool
    @NSManaged public var id: Int64
    @NSManaged public var date: Date
}

extension DBNote: Identifiable {

}

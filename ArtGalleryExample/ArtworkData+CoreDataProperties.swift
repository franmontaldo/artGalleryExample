//
//  ArtworkData+CoreDataProperties.swift
//  DataLayer
//
//  Created by francisco on 09/02/2024.
//
//

import Foundation
import CoreData


extension ArtworkData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtworkData> {
        return NSFetchRequest<ArtworkData>(entityName: "ArtworkData")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var descriptionDisplay: String?
    @NSManaged public var artistDisplay: String?
    @NSManaged public var imageID: String?
    @NSManaged public var dateDisplay: String?
    @NSManaged public var mediumDisplay: String?

}

extension ArtworkData : Identifiable {

}

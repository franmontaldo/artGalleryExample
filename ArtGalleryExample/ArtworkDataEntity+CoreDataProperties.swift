//
//  ArtworkDataEntity+CoreDataProperties.swift
//  DataLayer
//
//  Created by francisco on 09/02/2024.
//
//

import Foundation
import CoreData


extension ArtworkDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtworkDataEntity> {
        return NSFetchRequest<ArtworkDataEntity>(entityName: "ArtworkDataEntity")
    }

    @NSManaged public var artistDisplay: String?
    @NSManaged public var dateDisplay: String?
    @NSManaged public var descriptionDisplay: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageID: String?
    @NSManaged public var mediumDisplay: String?
    @NSManaged public var title: String?

}

extension ArtworkDataEntity : Identifiable {

}

//
//  ImageDataEntity+CoreDataProperties.swift
//  DataLayer
//
//  Created by francisco on 09/02/2024.
//
//

import Foundation
import CoreData


extension ImageDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDataEntity> {
        return NSFetchRequest<ImageDataEntity>(entityName: "ImageDataEntity")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageID: String?

}

extension ImageDataEntity : Identifiable {

}

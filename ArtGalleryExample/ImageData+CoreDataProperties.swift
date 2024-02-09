//
//  ImageData+CoreDataProperties.swift
//  DataLayer
//
//  Created by francisco on 09/02/2024.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageID: String

}

extension ImageData : Identifiable {

}

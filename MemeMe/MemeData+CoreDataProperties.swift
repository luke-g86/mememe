//
//  MemeData+CoreDataProperties.swift
//  MemeMe
//
//  Created by Lukasz on 22/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//
//

import Foundation
import CoreData


extension MemeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemeData> {
        return NSFetchRequest<MemeData>(entityName: "MemeData")
    }

    
    @NSManaged public var bottomText: String?
    @NSManaged public var memedImage: NSData?
    @NSManaged public var originalImage: NSData?
    @NSManaged public var topText: String?

}

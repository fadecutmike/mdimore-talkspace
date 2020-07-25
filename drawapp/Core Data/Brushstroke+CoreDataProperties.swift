//
//  Brushstroke+CoreDataProperties.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//
//

import Foundation
import CoreData


extension Brushstroke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Brushstroke> {
        return NSFetchRequest<Brushstroke>(entityName: "Brushstroke")
    }

    @NSManaged public var color: Data?
    @NSManaged public var ended: Date?
    @NSManaged public var path: Data?
    @NSManaged public var started: Date?
    @NSManaged public var thickness: Float
    
}

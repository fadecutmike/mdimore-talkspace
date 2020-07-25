//
//  Drawing+CoreDataProperties.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//
//

import Foundation
import CoreData


extension Drawing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drawing> {
        return NSFetchRequest<Drawing>(entityName: "Drawing")
    }

    @NSManaged public var thumbnail: Data?
    @NSManaged public var timestamp: Date?
    @NSManaged public var brushstrokes: NSOrderedSet?

}

// MARK: Generated accessors for brushstrokes
extension Drawing {

    @objc(insertObject:inBrushstrokesAtIndex:)
    @NSManaged public func insertIntoBrushstrokes(_ value: Brushstroke, at idx: Int)

    @objc(removeObjectFromBrushstrokesAtIndex:)
    @NSManaged public func removeFromBrushstrokes(at idx: Int)

    @objc(insertBrushstrokes:atIndexes:)
    @NSManaged public func insertIntoBrushstrokes(_ values: [Brushstroke], at indexes: NSIndexSet)

    @objc(removeBrushstrokesAtIndexes:)
    @NSManaged public func removeFromBrushstrokes(at indexes: NSIndexSet)

    @objc(replaceObjectInBrushstrokesAtIndex:withObject:)
    @NSManaged public func replaceBrushstrokes(at idx: Int, with value: Brushstroke)

    @objc(replaceBrushstrokesAtIndexes:withBrushstrokes:)
    @NSManaged public func replaceBrushstrokes(at indexes: NSIndexSet, with values: [Brushstroke])

    @objc(addBrushstrokesObject:)
    @NSManaged public func addToBrushstrokes(_ value: Brushstroke)

    @objc(removeBrushstrokesObject:)
    @NSManaged public func removeFromBrushstrokes(_ value: Brushstroke)

    @objc(addBrushstrokes:)
    @NSManaged public func addToBrushstrokes(_ values: NSOrderedSet)

    @objc(removeBrushstrokes:)
    @NSManaged public func removeFromBrushstrokes(_ values: NSOrderedSet)

}

//
//  Brushstroke+CoreDataClass.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Brushstroke)
public class Brushstroke: NSManagedObject {

    lazy var strokeColor:UIColor? = {
        guard let colorData = color else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
    }()
    
    lazy var brushPath:UIBezierPath? = {
        guard let drawingData = path else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData) as? UIBezierPath
    }()
}

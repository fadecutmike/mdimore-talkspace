//
//  CanvasViewModel.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//

import UIKit

class CanvasViewModel {
    var drawingItem: Drawing
    var lastBrushstroke: Brushstroke?
    
    init(_ drawing:Drawing) {
        drawingItem = drawing
    }
    
    lazy var savedBrushstrokes: [CAShapeLayer] = {
        var result = [CAShapeLayer]()
        if let strokes = drawingItem.brushstrokes {
            for stroke in strokes {
                if let stroke = stroke as? Brushstroke, let drawing = stroke.brushPath, drawing.isEmpty == false {
                    let layer = CAShapeLayer()
                    layer.path = drawing.cgPath
                    layer.lineWidth = CGFloat(stroke.thickness)
                    if let color = stroke.strokeColor { layer.strokeColor = color.cgColor }

                    result.append(layer)
                }
            }
        }
        
        return result
    }()
    
    lazy var createdText:String = {
        if let created = drawingItem.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            return "Created \(dateFormatter.string(from: created))"
        }
        return ""
    }()
    
    func createNewStroke(_ color: UIColor) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let newStroke = Brushstroke(context: context)
            if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
                newStroke.color = colorData
            }

            newStroke.thickness = 5.0
            newStroke.started = Date()
            lastBrushstroke = newStroke
        }
    }
    
    func finalizeStroke(path:UIBezierPath?) {
        if let last = lastBrushstroke, let drawing = path {
            last.ended = Date()
            if let pathData = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false) { last.path = pathData }
            drawingItem.addToBrushstrokes(last)
        }
    }
}

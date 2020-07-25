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
                    layer.lineCap = .round
                    layer.lineJoin = .round
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
    
    func createNewStroke(_ color: UIColor, _ lineWidth:Float) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let newStroke = Brushstroke(context: context)
            if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
                newStroke.color = colorData
            }

            newStroke.thickness = lineWidth
            newStroke.started = Date()
            lastBrushstroke = newStroke
        }
    }
    
    func finalizeStroke(path:UIBezierPath?, _ image:UIImage?) {
        if let last = lastBrushstroke, let drawing = path {
            last.ended = Date()
            if let pathData = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false) { last.path = pathData }
            drawingItem.addToBrushstrokes(last)
        }
        
        drawingItem.thumbnail = image?.pngData()
    }
}

// Helper methods
extension CanvasViewModel {
    func makeButton(bgColor:UIColor?, _ bgImage: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = .boldSystemFont(ofSize: 28.0)
        button.setTitle("\(bgColor == UIColor.black ? "X":"")", for: .normal)
        button.titleLabel?.layer.shadowOpacity = 0.25
        button.addTarget(nil, action: #selector(DetailViewController.didTap), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.shadowRadius = 1.25
        button.layer.shadowOffset = CGSize(width: 1.25, height: 1.25)
        button.layer.shadowOpacity = 0.55

        if let img = bgImage {
            button.setImage(img, for: .normal)
            button.tintColor = #colorLiteral(red: 0.9786700606, green: 0.6100003123, blue: 0.6867509484, alpha: 1)
            button.layer.shadowOpacity = 0.2
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.gray, for: .selected)
        }
        return button
    }
}

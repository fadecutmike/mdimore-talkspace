//
//  CanvasView.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//

import UIKit

protocol DrawDelegate {
    func brushstrokeEnded()
    func brushstrokeStarted()
}

class CanvasView: UIView {
	
	var drawColor = UIColor.black
    var brushSize: CGFloat = 5.0
    var delegate: DrawDelegate?
    var drawPath: UIBezierPath!
    private var preRenderImage: UIImage!
    private var lastPoint: CGPoint!
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		initBezierPath()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initBezierPath()
	}
	
	func initBezierPath() {
		drawPath = UIBezierPath()
		drawPath.lineCapStyle = CGLineCap.round
		drawPath.lineJoinStyle = CGLineJoin.round
	}
	
    func getImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { ctx in superview!.drawHierarchy(in: bounds, afterScreenUpdates: true) }
        
        return image
    }
    
	// MARK: - Render
	override func draw(_ rect: CGRect) {
		super.draw(rect)
        if preRenderImage != nil { preRenderImage.draw(in: bounds) }
		drawPath.lineWidth = brushSize
		drawColor.setStroke()
		drawPath.stroke()
	}

	// MARK: - Clearing
	func clear() {
        preRenderImage = nil
		drawPath.removeAllPoints()
		setNeedsDisplay()
	}
    
    func renderToImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        if preRenderImage != nil { preRenderImage.draw(in: bounds) }
        
        drawPath.lineWidth = brushSize
        drawColor.setFill()
        drawColor.setStroke()
        drawPath.stroke()
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

// MARK: - Touch input methods
extension CanvasView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        lastPoint = touch!.location(in: self)
        delegate?.brushstrokeStarted()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        let newPoint = touch!.location(in: self)
        
        drawPath.move(to: lastPoint)
        drawPath.addLine(to: newPoint)
        lastPoint = newPoint
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderToImage()
        setNeedsDisplay()
        delegate?.brushstrokeEnded()
        drawPath.removeAllPoints()
    }
}

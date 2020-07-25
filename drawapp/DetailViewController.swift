//
//  DetailViewController.swift
//  drawapp
//
//  Created by Michael Dimore on 7/25/20.
//  Copyright © 2020 Michael Dimore. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var brushOptions: UIStackView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var brushSizePreview: UIView!
    @IBOutlet weak var brushPreviewConstraint: NSLayoutConstraint!
    
    var viewModel: CanvasViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.delegate = self
        detailDescriptionLabel.text = viewModel?.createdText
        
        let brushColor:[UIColor] = [.black, .blue, .green, .red, .purple]
        brushColor.forEach({ (color) in
            if let btn = viewModel?.makeButton(bgColor: color) {
                brushOptions.addArrangedSubview(btn)
            }
        })
        
        if let eraserOption = viewModel?.makeButton(bgColor: .clear, UIImage(named: "eraser")) {
            brushOptions.addArrangedSubview(eraserOption)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load previous brushstrokes if they any exist in Core Data
        viewModel?.savedBrushstrokes.forEach({ bgView.layer.addSublayer($0)} )
        view.sendSubviewToBack(bgView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    @objc func didTap(_ sender: UIButton) {
        brushOptions.subviews.forEach({ (view) in
            if let btn = view as? UIButton { btn.setTitle("", for: .normal) }
        })
        
        sender.setTitle("X", for: .normal)
        if let color = sender.backgroundColor, color != .clear {
            canvas.drawColor = color
        } else {
            canvas.drawColor = .lightGray
        }
        brushSizePreview.backgroundColor = canvas.drawColor
    }
}

extension DetailViewController: DrawDelegate {
    
    func brushstrokeStarted() {
        viewModel?.createNewStroke(canvas.drawColor, Float(canvas.brushSize))
    }
    
    func brushstrokeEnded() {
        viewModel?.finalizeStroke(path: canvas.drawPath, canvas.getImage())
    }
}

// Change the brush size when UISlider value is updated
extension DetailViewController {
    @IBAction func brushSliderUpdated(_ sender: UISlider) {
        let newBrushValue = CGFloat(sender.value)
        let previewWidth = newBrushValue < 3.0 ? min(newBrushValue + 1, 3.0):newBrushValue
        
        canvas.brushSize = newBrushValue
        brushPreviewConstraint.constant = previewWidth
        UIView.animate(withDuration: 0.25) {
            self.brushSizePreview.layer.cornerRadius = previewWidth/2.0
            self.view.layoutIfNeeded()
        }
    }
}

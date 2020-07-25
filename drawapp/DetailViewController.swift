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
    
    var viewModel: CanvasViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.delegate = self
        
        detailDescriptionLabel.text = viewModel?.createdText
        
        let brushColor:[UIColor] = [.black, .blue, .green, .red, .purple]
        brushColor.forEach({ (color) in
            let btn = makeButton(bgColor: color)
            brushOptions.addArrangedSubview(btn)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load previous brushstrokes if they any exist in Core Data
        viewModel?.savedBrushstrokes.forEach({ canvas.layer.addSublayer($0)})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func makeButton(bgColor:UIColor, _ bgImage: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 9.0
        button.titleLabel?.font = .boldSystemFont(ofSize: 22.0)
        button.setTitle("\(bgColor == UIColor.black ? "X":"")", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        return button
    }
    
    @objc func didTap(_ sender: UIButton) {
        brushOptions.subviews.forEach({ (view) in
            if let btn = view as? UIButton { btn.setTitle("", for: UIControl.State.normal) }
        })
        
        if let color = sender.backgroundColor {
            canvas.drawColor = color
            sender.setTitle("X", for: UIControl.State.normal)
        } else {
            canvas.drawColor = .lightGray
        }
    }
}

extension DetailViewController: DrawDelegate {
    
    func brushstrokeStarted() {
        viewModel?.createNewStroke(canvas.drawColor)
    }
    
    func brushstrokeEnded() {
        viewModel?.finalizeStroke(path: canvas.drawPath)
    }
}

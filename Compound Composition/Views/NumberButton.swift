//
//  NumberButton.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/19/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NumberButton : UIControl {
    
    @IBInspectable var displayNumber: NSNumber! {
        didSet {
            self.label.text = "\((displayNumber ?? NSNumber(value: 0)).intValue)"
        }
    }
    
    private var keyView: UIView!
    private var label: UILabel!
    
    static let defaultBackground = UIColor.white
    static let touchBackground = UIColor.lightGray
    
    
    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(white: 0.7, alpha: 1.0)
        
        //configure white key
        self.keyView = UIView()
        self.keyView.backgroundColor = NumberButton.defaultBackground
        self.keyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.keyView)
        
        for roundView in [self, self.keyView!] {
            roundView.layer.cornerRadius = 5.0
            roundView.clipsToBounds = true
            roundView.layer.masksToBounds = true
        }
        
        addConstraints([(.top, -1), (.bottom, -1), (.left, 0), (.right, 0)], to: self.keyView, relativeTo: self)
            
        
        //configure label
        self.label = UILabel()
        self.label.text = "\((self.displayNumber ?? NSNumber(value: 0)).intValue)"
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.baselineAdjustment = .alignCenters
        self.label.font = UIFont.systemFont(ofSize: 23)
        self.label.textAlignment = .center
        
        self.keyView.addSubview(label)
        addConstraints([(.top, 6), (.bottom, -5), (.left, 5), (.right, -5)], to: self.label, relativeTo: self.keyView)
        
        self.layoutIfNeeded()
    }
    
    private func addConstraints(_ attributes: [(attribute: NSLayoutAttribute, constant: CGFloat)], to view: UIView, relativeTo parent: UIView) {
        for (attribute, constant) in attributes {
            NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: parent, attribute: attribute, multiplier: 1, constant: constant).isActive = true
        }
    }
    
    
    //MARK: - User Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touchIsInside(touch) {
            self.keyView.backgroundColor = NumberButton.touchBackground
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.keyView.backgroundColor = touchIsInside(touch) ? NumberButton.touchBackground : NumberButton.defaultBackground
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touchIsInside(touch) {
            self.keyView.backgroundColor = NumberButton.defaultBackground
            
            self.sendActions(for: .touchUpInside)
        }

    }
    
    func touchIsInside(_ touch: UITouch) -> Bool {
        return self.bounds.contains(touch.location(in: self))
    }
    
}

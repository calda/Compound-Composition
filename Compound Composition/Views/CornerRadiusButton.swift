//
//  CornerRadiusButton.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/31/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

@IBDesignable
class CornerRadiusButton : UIButton {
    
    @IBInspectable var cornerRadius: CGFloat! {
        didSet {
            self.layer.cornerRadius = self.cornerRadius ?? 0
            self.layer.masksToBounds = true
        }
    }
    
}

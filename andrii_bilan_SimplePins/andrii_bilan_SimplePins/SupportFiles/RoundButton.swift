//
//  RoundButton.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/26/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit

@IBDesignable public class MyButton: UIButton
{
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}

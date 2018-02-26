//
//  ViewConfigurate.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/26/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
import UIKit

@IBDesignable
class UIViewExplicit: UIView {

    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
  
}

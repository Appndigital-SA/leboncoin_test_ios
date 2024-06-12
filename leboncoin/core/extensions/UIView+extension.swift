//
//  UIView+extension.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
}


//
//  UIImageView+extension.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "placeholder")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}

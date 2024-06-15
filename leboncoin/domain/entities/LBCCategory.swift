//
//  LBCCategory.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import UIKit

struct LBCCategory: Decodable, Hashable {
    let id: Int
    let name: String
}

extension LBCCategory {
    func getColor() -> UIColor {
        switch id {
        case 1:
            return .gray
        case 2:
            return .red
        case 3:
            return .green
        case 4:
            return .blue
        case 5:
            return .orange
        case 6:
            return .purple
        case 7:
            return .brown
        case 8:
            return .cyan
        case 9:
            return .gray
        case 10:
            return .magenta
        case 11:
            return .systemPink
        default:
            return .gray
        }
    }
}

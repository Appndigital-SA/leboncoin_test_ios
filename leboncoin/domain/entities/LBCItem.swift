//
//  LBCItem.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Foundation

struct LBCItem {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let imagesUrl: LBCImagesUrl?
    let category: LBCCategory?
    let creationDate: Date
    let isUrgent: Bool
}

//
//  LBCConfiguration.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

struct LBCConfiguration {
    var selectedCategory: Int = 0
    var sortType: SortType = .dateDesc
    var onlyUrgent: Bool = false
}

enum SortType {
    case dateAsc
    case dateDesc
    case priceAsc
    case priceDesc
}
